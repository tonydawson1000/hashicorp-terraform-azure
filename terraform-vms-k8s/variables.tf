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

# Storage Container for 'terraform-vmsk8s' 'project'
variable "storage_container_name" {
  default = "terraform-vmsk8s-tfstate"
}

variable "storage_container_key" {
  default = "terraform.tfstate"
}