terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

# Učitavanje ostalih fajlova:
# network.tf, firewall.tf, compute.tf, app.tf, data.tf, private_dns.tf, private_endpoints.tf
