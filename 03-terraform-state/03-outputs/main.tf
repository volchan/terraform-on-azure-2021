# Terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.48.0"
    }
  }
}

#Azure provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-terraexample"
  location = "westus2"
}

#Create virtual network
resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet-dev-${azurerm_resource_group.rg.location}-001"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "subnet1" {
  name                 = "snet-dev-${azurerm_resource_group.rg.location}-001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.1.0/24"]
}

#Data Source for Shared Network Terraform State
data "terraform_remote_state" "terraformdemo" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-terraformstate"
    storage_account_name = "terrastatestorage2188"
    container_name       = "terraformdemo"
    key                  = "dev.terraform.tfstate"
  }

}

output "rg_name" {
  description = "resource group"
  value = azurerm_resource_group.rg.name
}

output "vnet_name" {
  description = "virtual network"
  value = azurerm_virtual_network.vnet1.name
}
