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

#####
# Create 3 Subnets
#####
resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  virtual_network_name = azurerm_virtual_network.tfnetworking.name
  resource_group_name  = azurerm_resource_group.tfnetworking.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "backend" {
  name                 = "backend"
  virtual_network_name = azurerm_virtual_network.tfnetworking.name
  resource_group_name  = azurerm_resource_group.tfnetworking.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "database" {
  name                 = "database"
  virtual_network_name = azurerm_virtual_network.tfnetworking.name
  resource_group_name  = azurerm_resource_group.tfnetworking.name
  address_prefixes     = ["10.0.3.0/24"]
}