#####
# Create a Virtual Network
#####
resource "azurerm_virtual_network" "tfvmsk8s" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.tfvmsk8s.name
  location            = azurerm_resource_group.tfvmsk8s.location
  address_space       = ["10.0.0.0/16"]

  tags = {
    Environment = var.tags_env
    Team        = var.tags_team
  }
}