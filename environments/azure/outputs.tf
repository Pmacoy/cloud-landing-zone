output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "vnet_id" {
  value = module.networking.vnet_id
}

output "subnet_ids" {
  value = module.networking.subnet_ids
}

output "log_analytics_workspace_id" {
  value = module.logging.log_analytics_workspace_id
}

output "github_actions_application_id" {
  value = module.iam.github_actions_application_id
}
