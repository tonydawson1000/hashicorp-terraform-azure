variable "resource_group_name" {
  default = "K8sRG"
}

variable "resource_group_location" {
  default = "uksouth"
}

variable "tags_env" {
  default = "K8s-PoC"
}

variable "tags_team" {
  default = "A-Team"
}

variable "vnet_name" {
  default = "K8sVNet"
}

variable "public_ip_name" {
  default = "K8sPubIp"
}

variable "load_balancer_fe_name" {
  default = "K8sLBFE"
}

variable "load_balancer_be_name" {
  default = "K8sLBBE"
}