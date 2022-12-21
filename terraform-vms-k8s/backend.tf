terraform {
  backend "azurerm" {
    resource_group_name = "TFVMsK8s"

    #####
    # "storage_container_name": "Visual Studio Enterprise – MPN"
    #####
    storage_account_name = "tfstatevmsk8smup0w4"

    #####
    # "storage_container_name": "Visual Studio Enterprise"
    ##### 
    #    storage_account_name = "<TO-DO>"

    container_name = "terraform-vmsk8s-tfstate"
    key            = "terraform.tfstate"
  }
}