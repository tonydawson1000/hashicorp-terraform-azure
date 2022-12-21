variable "resource_group_name" {
  default = "TFState"
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

# Storage Container for 'terraform-state' 'project'
variable "storage_container_name" {
  default = "terraform-state-tfstate"
}

variable "storage_container_key" {
  default = "terraform.tfstate"
}