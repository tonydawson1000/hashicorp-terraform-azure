#####
# Outputs
#####
output "resource_group_name" {
  value = azurerm_resource_group.tfvmsk8s.name
}

output "storage_account_name" {
  value = azurerm_storage_account.tfvmsk8s.name
}

output "storage_container_name" {
  value = azurerm_storage_container.tfvmsk8s.name
}