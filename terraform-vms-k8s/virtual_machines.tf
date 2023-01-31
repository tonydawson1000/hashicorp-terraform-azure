# https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-terraform

#####
# Create a Storage Account for Boot Diagnostics
#####
resource "azurerm_storage_account" "tfvmsk8sbootdiag" {
  name                     = "bootdiag${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.tfvmsk8s.name
  location                 = azurerm_resource_group.tfvmsk8s.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = var.tags_env
    Team        = var.tags_team
  }
}

#####
# Create an SSH Key
#####
resource "tls_private_key" "tfvmsk8s" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#####
# Create a VM
#####
resource "azurerm_linux_virtual_machine" "tfvmsk8s" {
  count               = var.cluster_count
  name                = "${var.vm_name}-${count.index}"
  resource_group_name = azurerm_resource_group.tfvmsk8s.name
  location            = azurerm_resource_group.tfvmsk8s.location

  #availability_set_id = azurerm_availability_set.tfvmsk8s.id

  # Single
  #network_interface_ids = [azurerm_network_interface.tfvmsk8s.id]

  # Multiple
  network_interface_ids = [element(azurerm_network_interface.tfvmsk8s.*.id, count.index)]

  size = "Standard_DS1_v2"

  #delete_os_disk_on_termination   = true
  #delete_data_disks_on_termination = true

  os_disk {
    name    = "osdisk-${count.index}"
    caching = "ReadWrite"
    #create_option        = "FromImage"
    storage_account_type = "Standard_LRS"
  }

  # storage_data_disk {
  #   name              = element(azurerm_managed_disk.disks.*.name, count.index)
  #   managed_disk_type = element(azurerm_managed_disk.disks.*.id, count.index)
  #   create_option     = "Attach"
  #   lun               = 1
  #   disk_size_gb      = element(azurerm_managed_disk.disks.*.disk_size_gb, count.index)
  # }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "${var.vm_name}-${count.index}"
  admin_username                  = var.vm_admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = tls_private_key.tfvmsk8s.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.tfvmsk8sbootdiag.primary_blob_endpoint
  }

  tags = {
    Environment = var.tags_env
    Team        = var.tags_team
  }
}



# #####
# # Create the Managed Disks
# #####
# resource "azurerm_managed_disk" "tfvmsk8s" {
#   count               = var.cluster_count
#   name                = "${var.data_disk_name}-${count.index}"
#   resource_group_name = azurerm_resource_group.tfvmsk8s.name
#   location            = azurerm_resource_group.tfvmsk8s.location

#   storage_account_type = "Standard_LRS"
#   create_option        = "Empty"
#   disk_size_gb         = "2"
# }

# #####
# # Create the Availability Set
# #####
# resource "azurerm_availability_set" "tfvmsk8s" {
#   name                = var.availability_set_name
#   resource_group_name = azurerm_resource_group.tfvmsk8s.name
#   location            = azurerm_resource_group.tfvmsk8s.location

#   platform_fault_domain_count  = 2
#   platform_update_domain_count = 2
#   managed                      = true
# }