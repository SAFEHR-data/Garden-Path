
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
data_directory_path="GoldZone/patients/"
```

Import dependencies and define functions to query data

``` python
#Function definitions inspired by MS docs
#at https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-directory-file-acl-python
import os, uuid, sys
from azure.storage.filedatalake import DataLakeServiceClient
from azure.core._match_conditions import MatchConditions
from azure.storage.filedatalake._models import ContentSettings
from azure.identity import DefaultAzureCredential, AzureCliCredential

class StorageClient:
    def __init__(self, storage_account_name):
        self.storage_account_name = storage_account_name
        self.service_client = self.initialize_storage_account_ad()

    def initialize_storage_account_ad(self):
        try:          
            credential = AzureCliCredential()
            service_client = DataLakeServiceClient(account_url=f"https://{self.storage_account_name}.dfs.core.windows.net", credential=credential)

            return service_client
        except Exception as e:
            print(e)
            return

    def download_file_from_directory(self, file_syst, directory, file_name):
        try:
            file_system_client = self.service_client.get_file_system_client(file_system=file_syst)
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
            return
        except Exception as e:
            print(e)
            return
                          
    def list_directory_contents(self, file_syst, directory):
        try:
            file_system_client = self.service_client.get_file_system_client(file_system=file_syst)

            paths = file_system_client.get_paths(path=directory)

            path_list = []
            for path in paths:
                path_list.append(path.name)
            return path_list

        except Exception as e:
            print(e)
            return
                             
    def create_directory(self, file_syst, directory):
        try:
            file_system_client = self.service_client.get_file_system_client(file_system=file_syst)
            file_system_client.create_directory(directory)
            return
        except Exception as e:
            print(e)
            return
    def upload_file_to_directory(self, file_syst, directory, uploaded_file_name, file_to_upload):
        try:
            file_system_client = self.service_client.get_file_system_client(file_system=file_syst)
            directory_client = file_system_client.get_directory_client(directory)
            file_client = directory_client.create_file(uploaded_file_name)
            with open(file_to_upload, 'r') as local_file:
                file_contents = local_file.read()
                file_client.append_data(data=file_contents, offset=0, length=len(file_contents))
                file_client.flush_data(len(file_contents))
            return
        except Exception as e:
            print(e)
            return
```

### Create an instance of our StorageClient object

``` python
client = StorageClient(storage_account_name)
```

### List the contents of the specified directory within the ADLS file system

``` python
available_files = client.list_directory_contents(input_data_fs_name, data_directory_path)
print(available_files)
```

### Download all files from a directory

``` python
[client.download_file_from_directory(input_data_fs_name, data_directory_path, datafile.rsplit("/",1)[-1]) for datafile in available_files]
```

### Download individual files from a directory

``` python
client.download_file_from_directory(input_data_fs_name, data_directory_path, available_files[0].rsplit("/", 1)[-1])
```

### Reading downloaded files with pandas

``` python
import pandas as pd
local_df = pd.read_parquet(f"downloaded_data/{available_files[0].rsplit('/',1)[-1]}")
local_df.head()
```
