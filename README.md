# hashicorp-terraform-azure
Repo to store Terraform config for Azure

Terraform to create a few resources in Azure
Requires an Azure Account

## Prereqs
#### - [Download Terraform](https://www.terraform.io/downloads)
#### - [Setup Terraform with Azure](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build)

## Steps
### [Install the Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

### Authenticate using the Azure CLI
#### - `az login`

### Set the 'Subscription Id'
#### - `az account set --subscription "<subscription-id>"`

### Create a Service Principal
#### - `az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"`

### Set your environment variables
#### - `export ARM_CLIENT_ID="<APPID_VALUE>"`
#### - `export ARM_CLIENT_SECRET="<PASSWORD_VALUE>"`
#### - `export ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"`
#### - `export ARM_TENANT_ID="<TENANT_VALUE>"`

---

## NOTE - Issue with `terraform apply` on WSL - [see here](https://github.com/microsoft/WSL/issues/4285#issuecomment-522201021)

### To find Azure Images
- https://www.kiloroot.com/where-did-microsoft-put-the-latest-azure-virtual-machine-ubuntu-images/

#### - `az vm image list-offers -p "Canonical" -l "uksouth" --output table`
#### - `az vm image list-skus -p "Canonical" -l "uksouth" -f 0001-com-ubuntu-server-jammy --output table`
---

## Order

- 1) Create a Resource Group
- 2) Create a Virtual Network
- 3) Create a Subnet
- 4) Create Public IP

- 5) Create Network Security Group and Firewall Rule
- 6) Create External Network Interface
- 7) Create Internal Network Interface


- 8) Connect the Security Group to the Network Interface