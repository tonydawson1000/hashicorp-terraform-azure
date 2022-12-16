# Generate a 'Random' number to use in the Globally Unique Storage Account Name
resource "random_string" "resource_code" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.k8srg.name
  location                 = azurerm_resource_group.k8srg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = var.tags_env
    Team        = var.tags_team
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}

# Outputs
output "storage_account_name" {
  value = azurerm_storage_account.tfstate.name
}

output "storage_container_name" {
  value = azurerm_storage_container.tfstate.name
}