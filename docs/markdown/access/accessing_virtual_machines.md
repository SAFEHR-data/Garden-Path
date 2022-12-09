TRE access and usage guide
================

As a user of FlowEHR you will need to create a virtual machine (VM)
within an Azure Workspace in order to access FlowEHR assets within a
secure Trusted Research Environment (TRE). The following instructions
describe the process of VM creation and access, as well as some initial
setup to access a Jupyter notebook once inside the VM.

## Creating a new VM

1.  Visit the FlowEHR Azure TRE landing page URL (please request from a
    member of the team)
2.  Select an appropriate Workspace from the list provided
3.  Under `Workspace Services`, select the `VMs` option
4.  Under `Resources`, you will see any previously created VMs. If there
    are none, select `Create New` in the upper right
5.  Select `Linux Machine > Create` (only option available as of
    05/12/2022)
6.  Choose an approriate name and description for the VM and select the
    desired image.
    - For linux VMs, there are two Ubuntu 18.04 images available. The
      `Data Science` variant may have a more relevant selection of
      packages installed.
7.  Select an approriate VM size from the dropdown menu. If you’re not
    sure of your requirements, opt for the `2 CPU | 8GB RAM` option. You
    can scale this up later if needed.
8.  Check the box marked `Shared storage` to enable access to workspace
    shared storage.
9.  Hit `Submit`. Your VM will start provisioning and you may need to
    wait a few minutes.

## Stopping a running VM

1.  Select the three dots at the upper right of the VM entry under
    `Resources`
2.  Select `Action > Stop`
3.  The VM will be stopped momentarily

## Starting a stopped VM

1.  Select the three dots at the upper right of the VM entry under
    `Resources`
2.  Select `Action > Start`

## Connecting to a created VM

1.  Visit the FlowEHR Azure TRE landing page URL
2.  Select an appropriate Workspace from the list provided
3.  Under `Workspace Services`, select the `VMs` option
4.  Under `Resources`, you will see any previously created VMs
5.  Select `Connect` under the VM you wish to connect to. This launches
    a separate browser window or tab.

## Deleting a VM

1.  Select the three dots at the upper right of the VM entry under
    `Resources`
2.  Select `Action > Stop`
3.  When the VM has been deallocated, repeat step 1. and select `Delete`
