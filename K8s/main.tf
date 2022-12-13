# Create a resource group
resource "azurerm_resource_group" "k8srg" {
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = {
    Environment = var.tags_env
    Team        = var.tags_team
  }
}

# Create a Virtual Network
resource "azurerm_virtual_network" "k8svnet" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.k8srg.name
  location            = azurerm_resource_group.k8srg.location
  address_space       = ["10.0.0.0/16"]

  tags = {
    Environment = var.tags_env
    Team        = var.tags_team
  }
}

# Create Subnets
resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  virtual_network_name = azurerm_virtual_network.k8svnet.name
  resource_group_name  = azurerm_resource_group.k8srg.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "backend" {
  name                 = "backend"
  virtual_network_name = azurerm_virtual_network.k8svnet.name
  resource_group_name  = azurerm_resource_group.k8srg.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "database" {
  name                 = "database"
  virtual_network_name = azurerm_virtual_network.k8svnet.name
  resource_group_name  = azurerm_resource_group.k8srg.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_public_ip" "k8sip" {
  name                = var.public_ip_name
  resource_group_name = azurerm_resource_group.k8srg.name
  location            = azurerm_resource_group.k8srg.location
  allocation_method   = "Static"
  domain_name_label   = "tempdomainnamelabel"#azurerm_resource_group.k8srg.name

  tags = {
    Environment = var.tags_env
    Team        = var.tags_team
  }
}

resource "azurerm_lb" "k8slbfe" {
  name                = var.load_balancer_fe_name
  resource_group_name = azurerm_resource_group.k8srg.name
  location            = azurerm_resource_group.k8srg.location

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.k8sip.id
  }

  tags = {
    Environment = var.tags_env
    Team        = var.tags_team
  }
}

resource "azurerm_lb_backend_address_pool" "k8slbbe" {
  name = var.load_balancer_be_name
  loadbalancer_id = azurerm_lb.k8slbfe.id
}