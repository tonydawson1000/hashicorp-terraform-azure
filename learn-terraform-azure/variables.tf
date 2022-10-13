variable "resource_group_name" {
  default = "K8sRG"
}

variable "location" {
  default = "uksouth"
}

variable "tags_env" {
  default = "K8s-PoC"
}

variable "tags_team" {
  default = "A-Team"
}

variable "virtual_network_name" {
  default = "K8sVnet"
}

variable "subnet_name" {
  default = "K8sInternal"
}

variable "public_ip_name" {
  default = "K8sPublicIp"
}

variable "network_security_group_name" {
  default = "K8sNetSecGroup"
}

variable "nic_name_external" {
  default = "K8sNicExternal"
}
variable "ip_config_name_external" {
  default = "K8sExternal"
}

variable "nic_name_internal" {
  default = "K8sNicInternal"
}
variable "ip_config_name_internal" {
  default = "K8sInternal"
}



variable "image_publisher" {
  default = "Canonical"
}
variable "image_offer" {
  default = "0001-com-ubuntu-server-jammy"
}
variable "image_sku" {
  default = "22_04-lts-gen2"
}
variable "image_version" {
  default = "latest"
}

variable "vm_total_node_count" {
  default = 7
}

variable "vm_control_plane_node_count" {
  default = 3
}

variable "vm_worker_node_count" {
  default = 3
}

# Bastion (x1)
variable "vm_name_bastion" {
  default = "K8sVM-Bastion"
}
variable "vm_hostname_bastion" {
  default = "bastion"
}
variable "vm_disk_bastion" {
  default = "K8sVMDisk-Bastion"
}

# Control Plane Nodes (x3)
variable "vm_name_cp" {
  default = "K8sVM-CP"
}
variable "vm_hostname_cp" {
  default = "c1-cp"
}
variable "vm_disk_cp" {
  default = "K8sVMDisk-CP"
}

# Worker Nodes (x3)
variable "vm_name_w" {
  default = "K8sVM-W"
}
variable "vm_hostname_w" {
  default = "c1-w"
}
variable "vm_disk_w" {
  default = "K8sVMDisk-W"
}
