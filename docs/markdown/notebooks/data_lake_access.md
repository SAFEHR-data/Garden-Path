
# Accessing EHR data from the TRE

This notebook describes the process of accessing EHR data stored within
a TRE-accessible Azure Data Lake Storage Gen2 (ADLS) instance.

### Authenticate with Azure

Open the link shown in a browser outside of the TRE, enter the code and
log in with your user account

``` python
!az login --use-device-code
```

### Set some key variables - the storage account name, input data filesystem name and the directory containing files

``` python
storage_account_name = "stflowehrdev"
input_data_fs_name="data-lake-storage-flowehr-dev"
gold_zone_path="GoldZone/patients/"
```

### Import dependencies and define functions to query data

``` python
#Function definitions inspired by MS docs
#at https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-directory-file-acl-python
import os, uuid, sys
from azure.storage.filedatalake import DataLakeServiceClient
from azure.core._match_conditions import MatchConditions
from azure.storage.filedatalake._models import ContentSettings
from azure.identity import DefaultAzureCredential, AzureCliCredential

def initialize_storage_account_ad(storage_account_name):
    try:  
        global service_client
        
        credential = AzureCliCredential()
        service_client = DataLakeServiceClient(account_url=f"https://{storage_account_name}.dfs.core.windows.net", credential=credential)
    
    except Exception as e:
        print(e)
def download_file_from_directory(storage_account, file_syst, directory, file_name):
    try:
        initialize_storage_account_ad(storage_account)
        file_system_client = service_client.get_file_system_client(file_system=file_syst)
        directory_client = file_system_client.get_directory_client(directory)
        if not os.path.exists("downloaded_data"):
            os.makedirs("downloaded_data")
        print
        local_file = open(f"downloaded_data/{file_name}",'wb')
        file_client = directory_client.get_file_client(file_name)
        download = file_client.download_file()
        downloaded_bytes = download.readall()
        local_file.write(downloaded_bytes)
        local_file.close()

    except Exception as e:
     print(e)
def list_directory_contents(storage_account, file_syst, directory):
    try:
        initialize_storage_account_ad(storage_account)
        file_system_client = service_client.get_file_system_client(file_system=file_syst)

        paths = file_system_client.get_paths(path=directory)
        
        path_list = []
        for path in paths:
            path_list.append(path.name)
        return path_list

    except Exception as e:
     print(e)
def create_directory(storage_account, file_syst, directory):
    try:
        initialize_storage_account_ad(storage_account)
        file_system_client = service_client.get_file_system_client(file_system=file_syst)
        file_system_client.create_directory(directory)
    
    except Exception as e:
     print(e)
def upload_file_to_directory(storage_account, file_syst, directory, uploaded_file_name, file_to_upload):
    try:
        initialize_storage_account_ad(storage_account)
        file_system_client = service_client.get_file_system_client(file_system=file_syst)
        directory_client = file_system_client.get_directory_client(directory)
        file_client = directory_client.create_file(uploaded_file_name)
        with open(file_to_upload, 'r') as local_file:
            file_contents = local_file.read()
            file_client.append_data(data=file_contents, offset=0, length=len(file_contents))
            file_client.flush_data(len(file_contents))
    except Exception as e:
        print(e)
            
        
```

List the contents of the specified directory within the ADLS file system

``` python
available_files = list_directory_contents(storage_account_name, input_data_fs_name, gold_zone_path)
```

Download all files found

``` python
[download_file_from_directory(storage_account_name, input_data_fs_name, gold_zone_path, datafile.rsplit("/",1)[-1]) for datafile in available_files]
```

Or individually

``` python
download_file_from_directory(storage_account_name, input_data_fs_name, gold_zone_path, available_files[0].rsplit("/", 1)[-1])
```

### Reading downloaded files with pandas

``` python
import pandas as pd
local_df = pd.read_parquet(f"downloaded_data/{available_files[0].rsplit('/',1)[-1]}")
local_df.head()
```
