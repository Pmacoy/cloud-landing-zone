locals {
  common_tags = merge(var.tags, { "landing-zone:module" = "azure/networking" })
}

resource "azurerm_virtual_network" "this" {
  name                = "${var.name}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space

  tags = local.common_tags
}

resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes
}

# One NSG per subnet: default-deny inbound from the internet, plus whatever
# extra rules the caller layered on for that subnet (e.g. allow HTTPS to a
# public-facing tier).
resource "azurerm_network_security_group" "this" {
  for_each = var.subnets

  name                = "${var.name}-${each.key}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "deny-inbound-internet"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  dynamic "security_rule" {
    for_each = each.value.extra_nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }

  tags = local.common_tags
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = var.subnets

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}

# ---------------------------------------------------------------------------
# NSG flow logs -> Storage Account, with traffic analytics -> Log Analytics
# (both provided by the logging module, wired together at the root level).
# ---------------------------------------------------------------------------

resource "azurerm_network_watcher_flow_log" "this" {
  for_each = var.enable_flow_logs ? var.subnets : {}

  name                 = "${var.name}-${each.key}-flow-log"
  network_watcher_name = var.network_watcher_name
  resource_group_name  = var.network_watcher_resource_group_name

  network_security_group_id = azurerm_network_security_group.this[each.key].id
  storage_account_id        = var.flow_log_storage_account_id
  enabled                   = true

  retention_policy {
    enabled = true
    days    = var.flow_log_retention_days
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = var.log_analytics_workspace_guid
    workspace_region      = var.log_analytics_workspace_region
    workspace_resource_id = var.log_analytics_workspace_id
    interval_in_minutes   = 10
  }

  tags = local.common_tags
}
