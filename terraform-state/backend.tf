terraform {
  backend "azurerm" {
    resource_group_name = "TFState"

    #####
    # "storage_container_name": "Visual Studio Enterprise – MPN"
    #####
    storage_account_name = "tfstatestaters5ljv"

    #####
    # "storage_container_name": "Visual Studio Enterprise"
    ##### 
    #    storage_account_name = "<TO-DO>"

    container_name = "terraform-state-tfstate"
    key            = "terraform.tfstate"
  }
}