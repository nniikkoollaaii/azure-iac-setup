terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.90.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "ToDo"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}


# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = "ToDo"
  tenant_id       = "ToDo"
}