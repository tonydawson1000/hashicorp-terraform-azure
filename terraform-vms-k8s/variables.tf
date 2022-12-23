variable "resource_group_name" {
  default = "TFVMsK8s"
}

variable "resource_group_location" {
  default = "uksouth"
}

variable "tags_env" {
  default = "dev"
}

variable "tags_team" {
  default = "Team-Terraform"
}

#####
# Storage Container for 'terraform-vmsk8s' 'project'
#####
variable "storage_container_name" {
  default = "terraform-vmsk8s-tfstate"
}

variable "storage_container_key" {
  default = "terraform.tfstate"
}

#####
# Networking
#####
variable "vnet_name" {
  default = "tfvmsk8svnet"
}

variable "sub_net_name" {
  default = "tfvmsk8ssubnet"
}

variable "public_ip_name" {
  default = "tfvmsk8spubip"
}

variable "network_security_group_name" {
  default = "tfvmk8snsg"
}

variable "nic_name" {
  default = "tfvmsk8snic"
}

variable "nic_ip_config" {
  default = "tfvmsk8snicipconfig"
}

variable "data_disk_name" {
  default = "tfvmsk8sdatadisk"
}

variable "availability_set_name" {
  default = "tfvmsk8savailabilityset"
}

variable "vm_name" {
  default = "vmubuntu"
}

variable "vm_admin_username" {
  default = "azureuser"
}

variable "cluster_count" {
  default = 4
  type    = number
}