#####
# Outputs
#####
output "resource_group_name" {
  value = azurerm_resource_group.tfstate.name
}

output "resource_group_location" {
  value = azurerm_resource_group.tfstate.location
}

output "storage_account_name" {
  value = azurerm_storage_account.tfstate.name
}

output "storage_container_name" {
  value = azurerm_storage_container.tfstate.name
}