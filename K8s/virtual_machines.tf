#####
# Create a Network Interface for a VM
#####
resource "azurerm_network_interface" "k8snic" {
  name                = "k8snic"
  resource_group_name = azurerm_resource_group.k8srg.name
  location            = azurerm_resource_group.k8srg.location

  ip_configuration {
    name                          = "k8snicconfig"
    subnet_id                     = azurerm_subnet.backend.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.k8sip.id
  }
}

#####
# Connect to the Security Group
#####
resource "azurerm_network_interface_security_group_association" "k8ssg" {
  network_interface_id      = azurerm_network_interface.k8snic.id
  network_security_group_id = azurerm_network_security_group.k8snsg.id
}

#####
# Create a Stoage Account for Boot Diagnostics
#####
resource "random_id" "randomId" {
  keepers = {
    resource_group = azurerm_resource_group.k8srg.name
  }

  byte_length = 8
}

resource "azurerm_storage_account" "vmbootdiag" {
  name                     = "bootdiag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.k8srg.name
  location                 = azurerm_resource_group.k8srg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

#####
# Create (and Display) an SSH Key
#####
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#####
# Create a VM
#####
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "myLinuxVM"
  resource_group_name = azurerm_resource_group.k8srg.name
  location            = azurerm_resource_group.k8srg.location

  network_interface_ids = [azurerm_network_interface.k8snic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }

  computer_name                   = "myLinuxVM"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.vmbootdiag.primary_blob_endpoint
  }
}
