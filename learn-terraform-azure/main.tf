# TODO : 
# https://medium.com/@yoursshaan2212/terraform-to-provision-multiple-azure-virtual-machines-fab0020b4a6e


# Configure the Azure provider
terraform {
  required_version = ">= 1.1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 1) Create a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = var.tags_env
    Team        = var.tags_team
  }
}

# 2) Create a Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  tags = {
    Environment = var.tags_env
    Team        = var.tags_team
  }

  address_space = ["10.0.0.0/16"]
}

# 3) Create a Subnet
resource "azurerm_subnet" "subnet" {
  name                = var.subnet_name
  resource_group_name = azurerm_resource_group.rg.name

  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# 4) Create Public IP
resource "azurerm_public_ip" "public_ip" {
  count               = var.vm_total_node_count
  name                = "${var.public_ip_name}-${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  allocation_method = "Dynamic"

  tags = {
    Environment = var.tags_env
    Team        = var.tags_team
  }
}

# 5) Create External Network Interface
resource "azurerm_network_interface" "externalnic" {
  count               = var.vm_total_node_count
  name                = "${var.nic_name_external}-${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name = "internal"



    #name      = "${var.ip_config_name_external}-${count.index}"
    subnet_id = azurerm_subnet.subnet.id
    #public_ip_address_id          = azurerm_public_ip.public_ip.id"${count.index}"
    private_ip_address_allocation = "Dynamic"
  }
}

# 6) Create Network Security Group and Firewall Rule
resource "azurerm_network_security_group" "nsg" {
  name                = var.network_security_group_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}



# 7) Create Internal Network Interface(s)
resource "azurerm_network_interface" "internalnic" {
  count               = var.vm_total_node_count
  name                = "${var.nic_name_internal}-${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "${var.ip_config_name_internal}-${count.index}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}





# # 8) Connect the Security Group to the Network Interface
# resource "azurerm_network_interface_security_group_association" "nisga" {
#   network_interface_id      = azurerm_network_interface.externalnic.[count.index].id
#   network_security_group_id = azurerm_network_security_group.nsg.id
# }



# # Generate random text for a unique Storage Account name
# resource "random_id" "random_id" {
#   keepers = {
#     # Generate a new ID only when a new resource group is defined
#     resource_group = azurerm_resource_group.rg.name
#   }

#   byte_length = 8
# }

# # Create Storage Account for boot diagnostics
# resource "azurerm_storage_account" "storage_account" {
#   name                = "diag${random_id.random_id.hex}"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location

#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

# # Create (and display) an SSH key
# resource "tls_private_key" "ssh" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# # Create virtual machine - Bastion
# resource "azurerm_linux_virtual_machine" "vm_bastion" {
#   name                = var.vm_bastion_name
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location

#   network_interface_ids = [azurerm_network_interface.nic.id]
#   size                  = "Standard_B1ms"

#   os_disk {
#     name                 = var.vm_bastion_diskname
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = var.image_publisher
#     offer     = var.image_offer
#     sku       = var.image_sku
#     version   = var.image_version
#   }

#   computer_name                   = var.vm_bastion_hostname
#   admin_username                  = "azureuser"
#   disable_password_authentication = true

#   admin_ssh_key {
#     username   = "azureuser"
#     public_key = tls_private_key.ssh.public_key_openssh
#   }

#   boot_diagnostics {
#     storage_account_uri = azurerm_storage_account.storage_account.primary_blob_endpoint
#   }
# }


# # Create virtual machine - Control Plane Nodes
# resource "azurerm_linux_virtual_machine" "vm_cp1" {
#   name                = var.vm_cp1_name
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location

#   network_interface_ids = [azurerm_network_interface.nic.id]
#   size                  = "Standard_B1ms"

#   os_disk {
#     name                 = var.vm_cp1_diskname
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = var.image_publisher
#     offer     = var.image_offer
#     sku       = var.image_sku
#     version   = var.image_version
#   }

#   computer_name                   = var.vm_cp1_hostname
#   admin_username                  = "azureuser"
#   disable_password_authentication = true

#   admin_ssh_key {
#     username   = "azureuser"
#     public_key = tls_private_key.ssh.public_key_openssh
#   }

#   boot_diagnostics {
#     storage_account_uri = azurerm_storage_account.storage_account.primary_blob_endpoint
#   }
# }



# # Create virtual machine - Worker Nodes
# resource "azurerm_linux_virtual_machine" "vm_w1" {
#   name                = var.vm_w1_name
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location

#   network_interface_ids = [azurerm_network_interface.nic.id]
#   size                  = "Standard_B1ms"

#   os_disk {
#     name                 = var.vm_w1_diskname
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = var.image_publisher
#     offer     = var.image_offer
#     sku       = var.image_sku
#     version   = var.image_version
#   }

#   computer_name                   = var.vm_w1_hostname
#   admin_username                  = "azureuser"
#   disable_password_authentication = true

#   admin_ssh_key {
#     username   = "azureuser"
#     public_key = tls_private_key.ssh.public_key_openssh
#   }

#   boot_diagnostics {
#     storage_account_uri = azurerm_storage_account.storage_account.primary_blob_endpoint
#   }
# }

