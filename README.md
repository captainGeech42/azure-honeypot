# azure-honeypot
Azure Honeypot Deployment (Terraform)

## Variables

The following environment variables are required:

* `ARM_CLIENT_ID`
* `ARM_CLIENT_SECRET`
* `ARM_SUBSCRIPTION_ID`
* `ARM_TENANT_ID`

(this assumes you will be authing via SP/Client Secret, you can auth in other ways if you set the right env vars)

The following variables can be changed to customize the plan

* `azure_region`: The Azure region to use
* `azure_rg_name`: The name of the Azure resource group to create
* `azure_sa_name`: The name of the Azure storage account to create
* `azure_law_name`: The name of the Azure log analytics workspace to create