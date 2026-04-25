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

resource "azurerm_user_assigned_identity" "chuie_aci_identity" {
  name = "id-chuie-aci-acrpull"
  resource_group_name = "rg-chuie"
  location = "Central US"
}

resource "azurerm_role_assignment" "chuie_acr_pull" {
  scope = data.azurerm_container_registry.chuie_acr.id
  role_definition_name = "AcrPull"
  principal_id = azurerm_user_assigned_identity.chuie_aci_identity.principal_id
}

data "azurerm_container_registry" "chuie_acr" {
  name = "acrchuieacmp2400"
  resource_group_name = "rg-chuie"
}

resource "azurerm_container_group" "chuie_aci" {
  name = "cg-my-app"
  location = "Central US"
  resource_group_name = "rg-chuie"
  os_type = "Linux"
  ip_address_type = "Public"
  dns_name_label = "chuie-myapp-demo"

  container {
    name = "my-app"
    image = "${data.azurerm_container_registry.chuie_acr.login_server}/my-app:${var.image_tag}"
    cpu = 0.5
    memory = 1.5

    ports {
      port = 8000
      protocol = "TCP"
    }

    environment_variables = {
      DJANGO_SECRET_KEY = var.django_secret_key
    }
  }

  image_registry_credential {
    server = data.azurerm_container_registry.chuie_acr.login_server
    user_assigned_identity_id = azurerm_user_assigned_identity.chuie_aci_identity.id
  }
  depends_on = [
    azurerm_role_assignment.chuie_acr_pull
  ]
}

output "container_fqdn" {
  value = azurerm_container_group.chuie_aci.fqdn
}
