terraform {
  backend "azurerm" {
    resource_group_name = "TFNetworking"

    #####
    # "storage_container_name": "Visual Studio Enterprise – MPN"
    #####
    storage_account_name = "tfstatenetworking018cx9"

    #####
    # "storage_container_name": "Visual Studio Enterprise"
    ##### 
    #    storage_account_name = "<TO-DO>"

    container_name = "terraform-networking-tfstate"
    key            = "terraform.tfstate"
  }
}