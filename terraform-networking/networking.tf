#####
# Create a Virtual Network
#####
resource "azurerm_virtual_network" "tfnetworking" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.tfnetworking.name
  location            = azurerm_resource_group.tfnetworking.location
  address_space       = ["10.0.0.0/16"]

  tags = {
    Environment = var.tags_env
    Team        = var.tags_team
  }
}