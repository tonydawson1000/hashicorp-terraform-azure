#####
# Outputs
#####
output "resource_group_name" {
  value = azurerm_resource_group.tfnetworking.name
}

output "storage_account_name" {
  value = azurerm_storage_account.tfnetworking.name
}

output "storage_container_name" {
  value = azurerm_storage_container.tfnetworking.name
}