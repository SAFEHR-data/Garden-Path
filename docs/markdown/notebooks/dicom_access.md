
# Accessing the DICOM service from the TRE

``` python
import requests
import pydicom
from pathlib import Path
from urllib3.filepost import encode_multipart_formdata, choose_boundary
from azure.identity import DefaultAzureCredential
```

### Set api URL and version

``` python
service_url="https://hdsflowehrdev-dicom-flowehr-dev.dicom.azurehealthcareapis.com"
version="v1"
base_url = f"{service_url}/{version}"
print(service_url)
```

### Authenticate to Azure

``` python
!az login --use-device-code
```

### Generate bearer token via DefaultAzureCredential

``` python
from azure.identity import DefaultAzureCredential, AzureCliCredential
credential = DefaultAzureCredential()
token = credential.credentials[3].get_token('https://dicom.healthcareapis.azure.com')
bearer_token = f'Bearer {token.token}'
```

## Create supporting methods to support multipart

- Requests libraries don’t directly support DICOMweb
- we add some function definitions here to support working with DICOM
  files

From Azure DICOM docs: \> encode_multipart_related takes a set of fields
(in the DICOM case, these libraries are generally Part 10 dam files) and
an optional user-defined boundary. It returns both the full body, along
with the content_type, which it can be used.

``` python
def encode_multipart_related(fields, boundary=None):
    if boundary is None:
        boundary = choose_boundary()

    body, _ = encode_multipart_formdata(fields, boundary)
    content_type = str('multipart/related; boundary=%s' % boundary)

    return body, content_type
```

``` python
# Create a requests session
client = requests.session()
```

## Verify authentication has performed correctly

``` python
headers = {"Authorization":bearer_token}
url= f'{base_url}/changefeed'

response = client.get(url,headers=headers)
if (response.status_code != 200):
    print('Error! Likely not authenticated!')
print(response.status_code)
```

## Loading example DICOM images and adding to the Azure DICOM service

``` python
from pydicom.data import get_testdata_file
from pydicom import dcmread
import matplotlib.pyplot as plt
filename_ct = get_testdata_file('CT_small.dcm')
```

``` python
ds = dcmread(filename_ct)
print(ds.file_meta)
```

``` python
plt.imshow(ds.pixel_array, cmap=plt.cm.bone)
```

### Retrieve relevant UIDs from original example dicom file

``` python
study_uid = ds.StudyInstanceUID
series_uid = ds.SeriesInstanceUID
instance_uid = ds.SOPInstanceUID
```

## (Optional, for testing here only) Upload to the DICOM service with `multipart\related`

Following [Azure
docs](https://learn.microsoft.com/en-us/azure/healthcare-apis/dicom/dicomweb-standard-apis-python#store-instances-using-multipartrelated).

``` python
dcm_filepath = filename_ct

with open(dcm_filepath,'rb') as reader:
    rawfile = reader.read()
files = {'file': ('dicomfile', rawfile, 'application/dicom')}

#encode as multipart_related
body, content_type = encode_multipart_related(fields = files)

headers = {'Accept':'application/dicom+json', "Content-Type":content_type, "Authorization":bearer_token}

url = f'{base_url}/studies'
response = client.post(url, body, headers=headers, verify=False)
# Response will be 409 if asset already uploaded
print(response.status_code, response.content)
```

## Querying the DICOM Service

- Search for studies

``` python
url = f"{base_url}/studies"
headers = {'Accept':'application/dicom+json', "Authorization":bearer_token}
params = {'StudyInstanceUID':study_uid}
response_query = client.get(url, headers=headers, params=params)
print(f"{response_query.status_code=}, {response_query.content=}")
```

- Search for series within a study

``` python
url = f'{base_url}/studies/{study_uid}/series'
headers = {'Accept':'application/dicom+json', "Authorization":bearer_token}
params = {'SeriesInstanceUID':series_uid}

response = client.get(url, headers=headers, params=params) #, verify=False)
print(f"{response.status_code=}, {response.content=}")
```

- Search by series

``` python
url = f'{base_url}/series'
headers = {'Accept': 'application/dicom+json', "Authorization":bearer_token}
params = {'SeriesInstanceUID': series_uid}
response = client.get(url, headers=headers, params=params)
print(f"{response.status_code=}, {response.content=}")
```

## Retrieve all instances within a study

``` python
url = f'{base_url}/studies/{study_uid}'
headers = {'Accept':'multipart/related; type="application/dicom"; transfer-syntax=*', "Authorization":bearer_token}

response = client.get(url, headers=headers) #, verify=False)
```

Instances retrieved as bytes - loop through returned items and convert
to files that can be read by pydicom

``` python
import requests_toolbelt as tb
from io import BytesIO

mpd = tb.MultipartDecoder.from_response(response)

retrieved_dcm_files = []
for part in mpd.parts:
    # headers returned as binary
    print(part.headers[b'content-type'])
    
    dcm = pydicom.dcmread(BytesIO(part.content))
    print(dcm.PatientName)
    print(dcm.SOPInstanceUID)
    retrieved_dcm_files.append(dcm)
```

We retrieve a list of our uploaded files (the single instance we just
uploaded)

``` python
retrieved_dcm_files[0].file_meta
```

``` python
assert retrieved_dcm_files[0].file_meta == ds.file_meta
assert retrieved_dcm_files[0].pixel_array.all() == ds.pixel_array.all()
```

``` python
plt.imshow(retrieved_dcm_files[0].pixel_array, cmap=plt.cm.bone)
```
