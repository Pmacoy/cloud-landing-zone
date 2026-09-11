terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.90, < 4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.47, < 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5"
    }
  }
}

# Authenticates via the environment (az login / ARM_* env vars / OIDC in
# CI) — no credentials are ever hardcoded here.
provider "azurerm" {
  features {}
}

provider "azuread" {}

data "azurerm_subscription" "current" {}
