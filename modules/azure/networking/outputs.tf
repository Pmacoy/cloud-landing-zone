output "vnet_id" {
  description = "ID of the created virtual network."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Name of the created virtual network."
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Map of subnet name => subnet ID."
  value       = { for name, subnet in azurerm_subnet.this : name => subnet.id }
}

output "network_security_group_ids" {
  description = "Map of subnet name => NSG ID protecting it."
  value       = { for name, nsg in azurerm_network_security_group.this : name => nsg.id }
}
