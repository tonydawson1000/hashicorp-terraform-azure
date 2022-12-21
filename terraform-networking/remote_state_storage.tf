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
resource "azurerm_resource_group" "tfnetworking" {
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = {
    Environment = var.tags_env
    Team        = var.tags_team
  }
}

#####
# Create a Storage Account for TFNetworking
#####
resource "azurerm_storage_account" "tfnetworking" {
  name                     = "tfstatenetworking${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.tfnetworking.name
  location                 = azurerm_resource_group.tfnetworking.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = var.tags_env
    Team        = var.tags_team
  }
}

#####
# Create a Storage Container for TFNetworking
#####
resource "azurerm_storage_container" "tfnetworking" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.tfnetworking.name
  container_access_type = "blob"
}