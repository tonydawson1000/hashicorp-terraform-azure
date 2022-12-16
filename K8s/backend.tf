terraform {
  backend "azurerm" {
    resource_group_name = "K8sRG"

    #####
    # "name": "Visual Studio Enterprise – MPN"
    ##### 
    #    storage_account_name = "tfstatej61osm"

    #####
    # "name": "Visual Studio Enterprise"
    ##### 
    #    storage_account_name = "tfstateduontk"

    container_name = "tfstate"
    key            = "terraform.tfstate"
  }
}  