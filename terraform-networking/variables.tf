variable "resource_group_name" {
  default = "TFNetworking"
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

# Storage Container for 'terraform-networking' 'project'
variable "storage_container_name" {
  default = "terraform-networking-tfstate"
}

variable "storage_container_key" {
  default = "terraform.tfstate"
}