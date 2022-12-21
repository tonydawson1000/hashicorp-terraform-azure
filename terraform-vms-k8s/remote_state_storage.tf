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
resource "azurerm_resource_group" "tfvmsk8s" {
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = {
    Environment = var.tags_env
    Team        = var.tags_team
  }
}

#####
# Create a Storage Account for TFVMsK8s
#####
resource "azurerm_storage_account" "tfvmsk8s" {
  name                     = "tfstatevmsk8s${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.tfvmsk8s.name
  location                 = azurerm_resource_group.tfvmsk8s.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = var.tags_env
    Team        = var.tags_team
  }
}

#####
# Create a Storage Container for TFVMsK8s
#####
resource "azurerm_storage_container" "tfvmsk8s" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.tfvmsk8s.name
  container_access_type = "blob"
}