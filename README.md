# hashicorp-terraform-azure
Repo to store Terraform config for Azure


## Resource needed to Create the Azure Storage (Used for Remote State Storage)

### 1) Resource Group
### 2) Random String Generator (used for RG Name)
### 3) Azure Storage Account
### 4) Azure Storage Container

## State File
### terraform show - reads and displays details from the state file
### terraform state list - shows a list of resources managed

# The Networking Infrastruicture needs 

## To Setup a Terraform Project to store state remotlly
### 1) Create a providers.tf file
### 2) Create a variable.tf file
### 3) Create a remote_state_storage.tf file
#### 3.1) This contains details of the following Resources to use for the Project
#### - Resource Group
#### - Storage Account
#### - Storage Container
### 4) terraform fmt
### 5) terraform init
### 6) terraform validate
### 7) terraform plan
### 8) terraform apply
### 9) Create a backend.tf file
#### 9.1) This sets up the backend/remote state storage details
#### 10) rerun terraform init and type 'yes' when asked to move the state to remote storage
#### 11) remove local tf state files 