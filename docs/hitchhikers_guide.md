# Login
- Use authenticator app - can be any authenticator app, google or microsoft
- Requires to have an NHS.net email. If you do not have access this needs to be arranged with an UCLH/Azure TRE Administrator
- View the available workspaces
	- This is a shared area commonly for people to collaborate on a project together.
	- This has shared storage 

# Create machine
- Click `virtual machines (VM)` to go into the personal list of available machines. Do not click on Connect as this will take you to a different place.
- Create a VM with the specified ID - this can be anything of your choosing as this is only visible to you.
- Use the machine with the lowest resources (CPU and RAM) that facilitates your work. This can always be upgraded later if you need. We recommend starting at `CPU=2, RAM=8GB`
- Wait for your VM to load, this might take a couple of minutes. You might need to refresh your screen to ensure that the VM has been deployed/provisioned/available.

# Conda Envs
- Conda has been configured to use a local mirror of `conda` and `conda-forge` in a framework called Nexus. This means that you will have access to most, but not all, packages and some of them will be outdated. 
- There are some conda environments that have already been made with pytorch/tensorflow/automl. Ideally those should be used in the first instance and packages can be added to that.
- If you wish to create your own environment, ensure that you have activated your base conda environment using `conda activate` prior to creating any other conda environments
- If you do wish to install other conda-like installers (e.g. `mamba`), ensure that the base conda environment has been activated so that the configuration files for `Nexus` has migrated into the mamba configuration. 
	- You'll probably have more success with `conda-forge` as your default channel as `Nexus` mirrors that more successfully. To do this, run: `conda config --add channels conda-forge`

# Pip Envs
- Pip environments have also been configured to work with `Nexus`. 
SPOTlight Data
￼

Id
5cbce1b2-768f-4161-b4ff-ce45db2ada5d

Creator
AA
AL-HINDAWI, Ahmed (UNIVERSITY COLLEGE LONDON HOSPITALS NHS FOUNDATION TRUST)
Type
import

Status
approved

Workspace

- This means that any `pip install` command should work out of the box
- We advise that you create a conda environment (as above), and install any packages that are not in conda using `pip` within that conda environment

# Visual Studio Code
There is an installation of Visual Studio Code but has limited functionality for extensions due to security reasons. It also does not have access to 

# R/RStudio
- There is an installation of R (version 4.1) and RStudio with basic packages.
- A mirror of packages available on CRAN has been developed and thus the installation of package is possible:
	- Specifically, rstan and brms installatio
SPOTlight Data
￼

Id
5cbce1b2-768f-4161-b4ff-ce45db2ada5d

Creator
AA
AL-HINDAWI, Ahmed (UNIVERSITY COLLEGE LONDON HOSPITALS NHS FOUNDATION TRUST)
Type
import

Status
approved

Workspace

- Copy and paste the link from the azure machine learning details 

# Airlock
To transfer files into the workspace/VM - there are two things you'll need:
1. An airlock transfer request which gives you a link to a `Storage Blob` that is a temporary container link (`SAS`) to upload to
2. `Microsoft Azure Storage Explorer` app - this is available for Windows, MacOS, and Linux (as a snap and a tar)

## Import File  Transfer 
- Ensure that the file you wish to transfer is a single file - if you wish to transfer many files, `zip` them.
- If you have not downloaded the `Microsoft Azure Storage Explorer` installed, do so now.
- Click on Airlock on the menu in the Azure TRE
- You'll be greeted with a list of current active requests (if any). 
- To start the process, click on `New Request` and then click on `import` - this will open a dialog on the right where you can name and describe your airlock transfer request
- Once you've created the transfer request, you'll be greeted with another dialog on the right describing the request. Copy the `SAS URL` - this step is important
- Open the `Microsoft Azure Storage Explorer`. You'll be greeted with a Get Started Page called `Storage Explorer`. If this is not available, exit and open it again or open a new window. Failing that, click on `Help`, then `Reset`
- Click on `Attach to a resource` - this will open a new window titled `Select a Resource`
- Click on `Blob container`
- Then select Shared access signature URL (SAS), then click Next
- Then past the `SAS` URL that copied from the Airlock transfer window in the Azure TRE into the `blob container SAS URL`. The Display name will be populated automatically.
- Click Next, and then Connect. After a moment, you will be greeted with a new Tab which has a `Upload` button on the top left hand side. Click that and select `Upload Files...`
- This will open another dialog box titled `Upload Files`. Click on the `...` next to the "No Files Selected"
- Click `Upload`. This will take a little while depending on the size of the file and the speed of your connection.
- Go back to the Azure TRE, you should still have the dialog with the Airlock open on the right hand size. If you have closed it, you can double click on the title of your upload that you created. Click on `Submit`.
- This will now require a person to approve the ingress of the data into the Azure TRE. You can view the progress of this from this screen.
- Once approved, your files will be located in the workspace
