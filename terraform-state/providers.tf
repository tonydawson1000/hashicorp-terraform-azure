terraform {
  required_version = ">= 1.3.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.35.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "random" {
}