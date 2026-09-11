output "resource_group_name" {
  value = azurerm_resource_group.state.name
}

output "storage_account_name" {
  value = azurerm_storage_account.state.name
}

output "containers" {
  value = { for env, c in azurerm_storage_container.state : env => c.name }
}
