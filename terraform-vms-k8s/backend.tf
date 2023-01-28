terraform {
  backend "azurerm" {
    resource_group_name = "TFVMsK8s"

    #####
    # Add the 'storage_account_name' (with the random name) from the output here 
    #####
    storage_account_name = "tfstatevmsk8sxp5s5m"

    container_name = "terraform-vmsk8s-tfstate"
    key            = "terraform.tfstate"
  }
}