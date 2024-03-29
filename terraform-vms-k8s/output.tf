#####
# Outputs
#####
output "resource_group_name" {
  value = azurerm_resource_group.tfvmsk8s.name
}

output "resource_group_location" {
  value = azurerm_resource_group.tfvmsk8s.location
}

output "storage_account_name" {
  value = azurerm_storage_account.tfvmsk8s.name
}

output "storage_container_name" {
  value = azurerm_storage_container.tfvmsk8s.name
}

output "vnet_name" {
  value = azurerm_virtual_network.tfvmsk8s.name
}

output "bootdiag_storage_account_name" {
  value = azurerm_storage_account.tfvmsk8sbootdiag.name
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.tfvmsk8s.*.public_ip_address
}

output "tls_public_key" {
  value = tls_private_key.tfvmsk8s.public_key_pem
}

output "tls_private_key" {
  value     = tls_private_key.tfvmsk8s.private_key_pem
  sensitive = true
}