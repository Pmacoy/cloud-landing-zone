# One-time bootstrap: creates the resource group + storage account/container
# that environments/azure's azurerm backend depends on. Local backend, applied
# once per subscription before `terraform init` runs in environments/azure.
#
#   terraform -chdir=bootstrap/azure init
#   terraform -chdir=bootstrap/azure apply -var="name_prefix=lz"

terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.90, < 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "azurerm_resource_group" "state" {
  name     = "${var.name_prefix}-tfstate-rg"
  location = var.location
}

resource "azurerm_storage_account" "state" {
  name                = substr(replace(lower("${var.name_prefix}tfstate${random_id.suffix.hex}"), "/[^a-z0-9]/", ""), 0, 24)
  resource_group_name = azurerm_resource_group.state.name
  location            = var.location

  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  blob_properties {
    versioning_enabled = true
  }
}

resource "azurerm_storage_container" "state" {
  for_each = toset(var.environments)

  name                  = "tfstate-${each.value}"
  storage_account_name  = azurerm_storage_account.state.name
  container_access_type = "private"
}
