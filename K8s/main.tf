#####
# Create a resource group
#####
resource "azurerm_resource_group" "k8srg" {
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = {
    Environment = var.tags_env
    Team        = var.tags_team
  }
}