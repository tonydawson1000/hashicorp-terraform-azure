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
# Create Subnet
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

  domain_name_label = "tfvmsk8s-${count.index}"

  sku = "Standard"

  tags = {
    Environment = var.tags_env
    Team        = var.tags_team
  }
}

#####
# Create Network Interface(s) for VM(s)
#####
resource "azurerm_network_interface" "tfvmsk8s" {
  count               = var.cluster_count
  name                = "${var.nic_name}-${count.index}"
  resource_group_name = azurerm_resource_group.tfvmsk8s.name
  location            = azurerm_resource_group.tfvmsk8s.location

  ip_configuration {
    name                          = var.nic_ip_config
    subnet_id                     = azurerm_subnet.tfvmsk8s.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.tfvmsk8s.*.id, count.index)
  }
}

#####
# Create a Network Security Group (Inbound and Outbound Firewall Rules)
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
# Connect the NICs to the Security Group
#####
resource "azurerm_network_interface_security_group_association" "tfvmsk8s" {
  count                     = var.cluster_count
  network_interface_id      = element(azurerm_network_interface.tfvmsk8s.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.tfvmsk8s.id
}

# #####
# # Create Load Balancer
# # The single point of contact for Clients
# # It evenly distributes inbound 'flows' of traffic that arrive at the front end addresses to the back end pool instances
# # Provides outbound connections for VM's inside your VNet
# #####
# resource "azurerm_lb" "k8slbfe" {
#   name                = var.load_balancer_fe_name
#   resource_group_name = azurerm_resource_group.k8srg.name
#   location            = azurerm_resource_group.k8srg.location

#   sku = "Standard"

#   frontend_ip_configuration {
#     name                 = "PublicIPAddress"
#     public_ip_address_id = azurerm_public_ip.k8sip.id
#   }

#   tags = {
#     Environment = var.tags_env
#     Team        = var.tags_team
#   }
# }

# #####
# # Create Back End Address Pool (for our Load Balancer)
# #####
# resource "azurerm_lb_backend_address_pool" "k8slbbe" {
#   name            = var.load_balancer_be_name
#   loadbalancer_id = azurerm_lb.k8slbfe.id
# }

# #####
# # Create NAT Pool (for our Load Balancer)
# #####
# resource "azurerm_lb_nat_pool" "k8slbnp" {
#   name                           = "ssh"
#   resource_group_name            = azurerm_resource_group.k8srg.name
#   loadbalancer_id                = azurerm_lb.k8slbfe.id
#   protocol                       = "Tcp"
#   frontend_port_start            = 50000
#   frontend_port_end              = 50119
#   backend_port                   = 22
#   frontend_ip_configuration_name = "PublicIPAddress"
# }

# #####
# # Create Health Probe (for our Load Balancer)
# #####
# resource "azurerm_lb_probe" "k8slbhp" {
#   name            = "http-probe"
#   loadbalancer_id = azurerm_lb.k8slbfe.id
#   protocol        = "Http"
#   request_path    = "/"
#   port            = 80
# }

# #####
# # Create Load Balancer Rule
# #####
# # resource "azurerm_lb_rule" "k8slbrule" {
# #   name                           = "k8sLBRule"
# #   loadbalancer_id                = azurerm_lb.k8slbfe.id
# #   protocol                       = "Tcp"
# #   frontend_port                  = 3389
# #   backend_port                   = 3389
# #   frontend_ip_configuration_name = "PublicIPAddress"
# # }

# #####
# # Create Load Balancer 'Outbound' Rule
# #####
# resource "azurerm_lb_outbound_rule" "k8slboutrule" {
#   name                    = "k8sLBOutRule"
#   loadbalancer_id         = azurerm_lb.k8slbfe.id
#   protocol                = "Tcp"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.k8slbbe.id

#   frontend_ip_configuration {
#     name = "PublicIPAddress"
#   }
# }

# #####
# # Create Load Balancer NAT Rule
# #####
# resource "azurerm_lb_nat_rule" "k8slbnatrule" {
#   name                           = "RDPAccess"
#   resource_group_name            = azurerm_resource_group.k8srg.name
#   loadbalancer_id                = azurerm_lb.k8slbfe.id
#   protocol                       = "Tcp"
#   frontend_port                  = 3389
#   backend_port                   = 3389
#   frontend_ip_configuration_name = "PublicIPAddress"
# }