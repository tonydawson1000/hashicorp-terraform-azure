#####
# Generate a 'Random' number - can be used for unique resource names
#####
resource "random_string" "resource_code" {
  length  = 6
  special = false
  upper   = false
}

#####
# Create a Resource Group
#####
resource "azurerm_resource_group" "tfstate" {
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = {
    Environment = var.tags_env
    Team        = var.tags_team
  }
}

#####
# Create a Storage Account for TFState
#####
resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = var.tags_env
    Team        = var.tags_team
  }
}

#####
# Create a Storage Container for TFState
#####
resource "azurerm_storage_container" "tfstate" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}