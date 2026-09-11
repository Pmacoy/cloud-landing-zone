locals {
  common_tags = merge(var.tags, { "landing-zone:module" = "azure/logging" })
}

data "azurerm_subscription" "current" {}

# ---------------------------------------------------------------------------
# Log Analytics workspace: destination for the subscription Activity Log,
# NSG flow log traffic analytics, and any workload diagnostic settings.
# ---------------------------------------------------------------------------

resource "azurerm_log_analytics_workspace" "this" {
  name                = "${var.name}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days

  tags = local.common_tags
}

# ---------------------------------------------------------------------------
# Storage account: durable archive for NSG flow logs (storage account names
# must be globally unique and lowercase-alphanumeric, hence the random suffix).
# ---------------------------------------------------------------------------

resource "random_id" "storage_suffix" {
  byte_length = 4
}

resource "azurerm_storage_account" "logs" {
  name                = substr(replace(lower("${var.name}logs${random_id.storage_suffix.hex}"), "/[^a-z0-9]/", ""), 0, 24)
  location            = var.location
  resource_group_name = var.resource_group_name

  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"

  public_network_access_enabled   = true # flow-log delivery requires this; tighten with network_rules below
  allow_nested_items_to_be_public = false

  network_rules {
    default_action = "Allow" # Azure's flow-log service does not support private-endpoint delivery yet
    bypass         = ["AzureServices"]
  }

  blob_properties {
    delete_retention_policy {
      days = var.log_retention_days
    }
  }

  tags = local.common_tags
}

# ---------------------------------------------------------------------------
# Network Watcher: required for NSG flow logs. Many subscriptions already get
# one auto-created per region (in "NetworkWatcherRG"); set
# create_network_watcher = false and point the networking module at that one
# instead of creating a duplicate.
# ---------------------------------------------------------------------------

resource "azurerm_network_watcher" "this" {
  count = var.create_network_watcher ? 1 : 0

  name                = "${var.name}-network-watcher"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = local.common_tags
}

# ---------------------------------------------------------------------------
# Subscription Activity Log -> Log Analytics (control-plane audit trail,
# the Azure analogue of AWS CloudTrail).
# ---------------------------------------------------------------------------

resource "azurerm_monitor_diagnostic_setting" "activity_log" {
  count = var.enable_subscription_activity_log ? 1 : 0

  name                       = "${var.name}-activity-log"
  target_resource_id         = data.azurerm_subscription.current.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  enabled_log {
    category = "Administrative"
  }
  enabled_log {
    category = "Security"
  }
  enabled_log {
    category = "Policy"
  }
  enabled_log {
    category = "Alert"
  }
}
