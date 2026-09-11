output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.this.id
}

output "log_analytics_workspace_guid" {
  description = "Workspace GUID (workspace ID, as opposed to resource ID) of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.this.workspace_id
}

output "storage_account_id" {
  description = "Resource ID of the storage account flow logs and diagnostics are archived to."
  value       = azurerm_storage_account.logs.id
}

output "network_watcher_name" {
  description = "Name of the Network Watcher used for NSG flow logs (created by this module, or the existing one passed in)."
  value       = var.create_network_watcher ? azurerm_network_watcher.this[0].name : var.existing_network_watcher_name
}

output "network_watcher_resource_group_name" {
  description = "Resource group of the Network Watcher used for NSG flow logs (created by this module, or the existing one passed in)."
  value       = var.create_network_watcher ? var.resource_group_name : var.existing_network_watcher_resource_group_name
}
