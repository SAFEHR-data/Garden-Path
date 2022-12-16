# TRE access and usage guide

As a user of FlowEHR you will need to create a virtual machine (VM)
within an Azure Workspace in order to access FlowEHR assets within a
secure Trusted Research Environment (TRE). The following instructions
describe the process of VM creation and access, as well as some initial
setup to access a Jupyter notebook once inside the VM.

This documentation relies heavily upon the official [AzureTRE
docs](https://microsoft.github.io/AzureTRE/using-tre/tre-for-research/using-vms/)
which should be consulted before performing the below steps.

## Creating a new VM

1. Visit the FlowEHR Azure TRE landing page URL (please request from a
    member of the team)
2. Select an appropriate Workspace from the list provided
3. Under `Workspace Services`, select the `VMs` option
4. Under `Resources`, you will see any previously created VMs. If there
    are none, select `Create New` in the upper right
5. Select `Linux Machine > Create` (only option available as of
    05/12/2022)
6. Choose an approriate name and description for the VM and select the
    desired image.
    - For linux VMs, there are two Ubuntu 18.04 images available. The
      `Data Science` variant may have a more relevant selection of
      packages installed.
7. Select an approriate VM size from the dropdown menu. If you’re not
    sure of your requirements, opt for the `2 CPU | 8GB RAM` option. You
    can scale this up later if needed.
8. Check the box marked `Shared storage` to enable access to workspace
    shared storage.
9. Hit `Submit`. Your VM will start provisioning and you may need to
    wait a few minutes.

## Stopping a running VM

1. Select the three dots at the upper right of the VM entry under
    `Resources`
2. Select `Action > Stop`
3. The VM will be stopped momentarily

## Starting a stopped VM

1. Select the three dots at the upper right of the VM entry under
    `Resources`
2. Select `Action > Start`

## Connecting to a created VM

1. Visit the FlowEHR Azure TRE landing page URL
2. Select an appropriate Workspace from the list provided
3. Under `Workspace Services`, select the `VMs` option
4. Under `Resources`, you will see any previously created VMs
5. Select `Connect` under the VM you wish to connect to. This launches
    a separate browser window or tab.

## Deleting a VM

1. Select the three dots at the upper right of the VM entry under
    `Resources`
2. Select `Action > Stop`
3. When the VM has been deallocated, repeat step 1. and select `Delete`

## Installing software within the VM

As the VM is located within a TRE, most outbound internet access is
restricted.

### GitHub

Access to repositories hosted on https://github.com/ is restricted. Repositories can be mirrored on an ad-hoc basis to a TRE-accessible [Gitea](https://gitea.io) instance, where this documentation can also be found.

You should be supplied with the URL for the Gitea instance during your onboarding. If you have not received the Gitea URL, please request it from member of the team.

### APT packages

The VM has access to software packages via a
[Nexus](https://microsoft.github.io/AzureTRE/tre-templates/shared-services/nexus/)
mirror

### Python packages via Conda and PyPI

The Nexus mirror provides mirrored access to packages available via
conda forge and PyPI via the standard `pip install` and `conda install`
command line interfaces.

## Example: Running a Jupyter notebook from this documentation within a virtual environment

Within a TRE VM:

- Visit the Gitea URL provided alongside this documentation
- Select 'Explore' from the top left
- Select the 'End-User-Docs' repository
- Copy the HTTPS link to the repository

The following code

- Clones this documentation repo
- Creates a virtual environment
- Activates the environment
- Installs `jupyterlab` and `ipykernel` within the virtual environment  
- Makes the virtual environment available as a kernel within a Jupyter
  Lab environment
- Launches Jupyter Lab

Open a terminal within the VM and create a virtual environment with Conda

``` bash
conda create -n my_virtual_environment python=3.10
conda activate my_virtual_environment
```

You may be prompted by `conda` to initialise your shell. Run

```bash
conda init bash
```

and restart your terminal. Run the following commands in the restarted terminal to clone this documentation repo and install dependencies

``` bash
git clone ${gitea-repository-url}
cd End-User-Docs/docs/notebooks
conda create -n my_virtual_environment python=3.10
conda activate my_virtual_environment
conda install jupyterlab ipykernel
pip install -r requirements.txt
python -m ipykernel install --user --name=my_env
```

A Jupyter Lab environment can then be launched by running

```bash
jupyter lab
```

Within this environment, navigate to the example notebooks provided. When running the notebooks, ensure the python kernel is set to the name defined by the earlier `python -m ipykernel install` command.

## Accessing EHR and DICOM data within the TRE

This documentation is accompanied by Jupyter notebook files which provide detailed examples of accessing and viewing EHR and DICOM data from within a Jupyter Lab environment within a TRE VM.

Before launching the notebooks and after following the steps in the [above example](#example-running-a-jupyter-notebook-from-this-documentation-with-with-a-virtual-environment), install required dependencies within your created virtual environment with

```bash
pip install -r requirements.txt
```

### A note on the data accessible from the TRE

Data provided has gone through an anonymisation step and will not entirely look like the original data due to the removal of PII and consequent structural changes that may appear as a result, such as line break removals.

As such, structural elements of reports such as line breaks or sentence lengths should **not** be used to generate features as inputs to machine learning models.