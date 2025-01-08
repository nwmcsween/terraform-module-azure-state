# Azure State Module

A common issue with Terraform is how to automate state creation, guides generally leave that bit out or recommend
deploying through a manual process which can lead to public access of state and secrets.
Instead of a manual process we can use terraform itself to create the state.

First we need to create the resources to hold the local state, this is largely cloud platform specific and in the case
of azure would be:

https://github.com/nwmcsween/terraform-module-azure-state/blob/1fd759a2730a8e0fec21fbfd487678e5ef9cf1bd/azure.tf

The backend specific part which creates a local file using partial backend configuration to work with multiple deployments such as dev, prod, staging:

https://github.com/nwmcsween/terraform-module-azure-state/blob/1fd759a2730a8e0fec21fbfd487678e5ef9cf1bd/backend.tf

Next we need to create a `null` resource to run a local-exec /after/ terraform exits and only run when the tfbackend file changes or is new, this is a bit hard as we need to run terraform within terraform but only after the parent terraform instance has completed, with POSIX shell we would fork and wait on the $PPID, within Powershell it's a bit more involved.

https://github.com/nwmcsween/terraform-module-azure-state/blob/1fd759a2730a8e0fec21fbfd487678e5ef9cf1bd/migrate.tf

where the Powershell migration script is is:

https://github.com/nwmcsween/terraform-module-azure-state/blob/1fd759a2730a8e0fec21fbfd487678e5ef9cf1bd/assets/migrate_state.ps1

and the shell version is:

https://github.com/nwmcsween/terraform-module-azure-state/blob/1fd759a2730a8e0fec21fbfd487678e5ef9cf1bd/assets/migrate_state.sh

This waits for the parent process (terraform) to exit and then runs terraform again to migrate the state to the backend we just created automating state migration within terraform itself!