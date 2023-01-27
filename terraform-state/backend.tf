terraform {
  backend "azurerm" {
    resource_group_name = "TFState"

    #####
    # Add the 'storage_account_name' (with the random name) from the output here 
    #####
    storage_account_name = "tfstate2y6ck5"

    container_name = "terraform-state-tfstate"
    key            = "terraform.tfstate"
  }
}