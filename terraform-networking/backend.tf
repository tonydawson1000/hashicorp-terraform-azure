terraform {
  backend "azurerm" {
    resource_group_name = "TFNetworking"

    #####
    # Add the 'storage_account_name' (with the random name) from the output here 
    #####
    storage_account_name = "tfstatenetworkingtfgysg"

    container_name = "terraform-networking-tfstate"
    key            = "terraform.tfstate"
  }
}