# FlowEHR TRE Workspace User Guide

## Table of Contents

- [Welcome to your FlowEHR TRE Workspace](#welcome-to-your-flowehr-tre-workspace)
- [The TRE Landing Page](#the-tre-landing-page)
- [Using a Workspace](#using-a-workspace)
- [Shared Services](#shared-services)
    - [Gitea](#gitea)
    - [Nexus](#nexus)

## Welcome to your FlowEHR TRE Workspace

The FlowEHR TRE (Trusted Research Environment) provides a safe and secure
environment to run clinical research on real data generated in
clinical settings. The FlowEHR TRE builds upon the work of the
[Microsoft Azure TRE](https://github.com/microsoft/AzureTRE) to provide
access to cloud-scale computing environments to conduct
real-world Machine Learning experiments from initial inception through
to operational deployment.

TRE Workspaces are designed to be project-specific, with access to the Workspace
resources and Workspace data restricted to the users assigned to the Workspace.
Users from other Workspaces will not be able to see or interact with your
Workspace resources or data.


## The TRE Landing Page

TRE Workspaces are deployed to a virtual private network and the resources
available in the Workspace are designed to have no direct internet access and
are not accessible from the internet either.

To get access to your TRE Workspace, you must first logon to the TRE portal.
Your TRE administrator will provide you with the URL to access the portal along
with a logon id that grants you access to Workspace resources.

Once logged-in, you will see the TRE Landing Page, displaying:

1. The TRE Header
2. The TRE navigation side-panel and
3. The 'Workspaces' page

The 'Workspaces' page contains Widget(s) for the Workspaces that you have been
granted access to.

Each Widget consists of a:

1. Name
2. Description
3. Information Button
4. Breadcrumb Menu

Clicking the 'Name' field of a Workspace widget will connect you to the Workspace.

## Using a Workspace

Once connected to a workspace, you'll be able to see the services installed in
the Workspace and also the Shared Services available to all Workspaces.

Only TRE Administrators or Workspace Owners can add Services to a Workspace.
However, certain Workspace Services provide User Resources which enable all
workspace users to add these resources to the Workspace. Specifically,
the Virtual Desktop Service provides a Virtual Machine User Resource. Once
the Workspace Owner has added a Virtual Desktop Service to the Workspace,
users can connect to the service and add Virtual Machines for their personal
use.

The Virtual Machines in your Workspace
allow you to interact with the private resources in the Workspace
and with the Shared Services common to all workspaces.

Detailed instructions for using a VM can be found in the
[Accessing Virtual Machines](accessing_virtual_machines.md)
document

## Shared Services

Shared Services provide access to resources that you would otherwise
need to access over the internet. Shared Services include:

1. [Gitea](#gitea)
2. [Nexus](#nexus)
3. Firewall

The Shared Services are available for use by all workspaces, but their
configuration can only be changed by the TRE administrators

### Gitea

Gitea is used in the TRE to mirror code repositories from the internet.
You can browse the repositories available in Gitea from your Workspace
VM using the URL https://gitea-&lt;tre-id&gt;.azurewebsites.com.
*(Check with your TRE administrator for the correct URL)*

Contact your TRE administrator if you need to add a git repository to
the Gitea service.

Gitea is also available as a Workspace service, this is useful if you
wish to mirror a private repository, without making this accessible
from other Workspaces.

Whilst Gitea is used to mirror repositories from the internet, for
security reasons, the server does not allow you to push changes to
internet sources.

### Nexus

Nexus is used in the TRE to provide a package mirror for popular
software tools. Installation tools on your VMs are configured to
pull from the Nexus server rather than directly from the internet.

You can explore the available repositories mirrored by the Nexus
server from your VM using
https://nexus-&lt;tre-id&gt;.&lt;location&gt;.azurewebsites.com.
*(Check with your TRE administrator for the correct URL)*

Click on the 'Browse' link to see the full list of repositories
that are in the Nexus mirror.
