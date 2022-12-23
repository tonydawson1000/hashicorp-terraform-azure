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

#####
# Create Subnets
#####
resource "azurerm_subnet" "tfvmsk8s" {
  name                 = var.sub_net_name
  virtual_network_name = azurerm_virtual_network.tfvmsk8s.name
  resource_group_name  = azurerm_resource_group.tfvmsk8s.name
  address_prefixes     = ["10.0.1.0/24"]
}

#####
# Create Public IPs (for our VMs)
#####
resource "azurerm_public_ip" "tfvmsk8s" {
  count               = var.cluster_count
  name                = "${var.public_ip_name}-${count.index}"
  resource_group_name = azurerm_resource_group.tfvmsk8s.name
  location            = azurerm_resource_group.tfvmsk8s.location
  allocation_method   = "Static"

  #####
  # "name": "Visual Studio Enterprise – MPN"
  ##### 
  domain_name_label = "tfvmsk8s-${count.index}" #azurerm_resource_group.tfvmsk8s.name

  #####
  # "name": "Visual Studio Enterprise"
  ##### 
  #  domain_name_label = "tempdomainnamelabel" #azurerm_resource_group.k8srg.name

  sku = "Standard"

  tags = {
    Environment = var.tags_env
    Team        = var.tags_team
  }
}

#####
# Create Network Security Group (Inbound and Outbound Firewall Rules)
#####
resource "azurerm_network_security_group" "tfvmsk8s" {
  name                = var.network_security_group_name
  resource_group_name = azurerm_resource_group.tfvmsk8s.name
  location            = azurerm_resource_group.tfvmsk8s.location

  security_rule {
    name      = "SSH"
    priority  = 1001
    direction = "Inbound"

    access   = "Allow"
    protocol = "Tcp"

    source_port_range      = "*"
    destination_port_range = "22"

    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = var.tags_env
    Team        = var.tags_team
  }
}

#####
# Connect to the Security Group
#####
resource "azurerm_network_interface_security_group_association" "tfvmsk8s" {
  count                     = var.cluster_count
  network_interface_id      = element(azurerm_network_interface.tfvmsk8s.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.tfvmsk8s.id
}