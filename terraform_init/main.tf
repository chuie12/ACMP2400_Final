terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.68.0"
    }
  }

  backend "azurerm" {
    resource_group_name = "rg-acmp-final"
    storage_account_name = "acmp2400storageaccount"
    container_name = "big-tf-state-acmp2400"
    key = "curtis-huie/acmp2400-final.tfstate"
    use_azuread_auth = true
  }
}

provider "azurerm" {
  features {}
}

variable "image_tag" {
type = string
default = "latest"
}

variable "django_secret_key" {
type = string
sensitive = true
}

resource "azurerm_container_registry" "chuie_acr" {
  name = "acrchuieacmp2400"
  resource_group_name = "rg-chuie"
  location = "Central US"
  sku = "Basic"
  admin_enabled = true
}
