output "custom_role_definition_id" {
  description = "Resource ID of the custom landing-zone operator role definition."
  value       = azurerm_role_definition.operator.role_definition_resource_id
}

output "github_actions_application_id" {
  description = "Client (application) ID of the GitHub Actions app registration (null if enable_github_oidc is false)."
  value       = try(azuread_application.github_actions[0].client_id, null)
}

output "github_actions_service_principal_object_id" {
  description = "Object ID of the GitHub Actions service principal (null if enable_github_oidc is false)."
  value       = try(azuread_service_principal.github_actions[0].object_id, null)
}
