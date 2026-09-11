# ---------------------------------------------------------------------------
# Custom least-privilege role: narrower than built-in Contributor. Grants the
# everyday landing-zone actions (read everything, write to networking/compute/
# storage namespaces) without secret/key-management or RBAC-modification
# rights.
# ---------------------------------------------------------------------------

resource "azurerm_role_definition" "operator" {
  name        = var.custom_role_name
  scope       = var.custom_role_assignable_scopes[0]
  description = "Landing zone operator: can manage core workload resources but cannot modify RBAC, policy, or read secrets."

  permissions {
    actions = [
      "Microsoft.Network/*",
      "Microsoft.Compute/*",
      "Microsoft.Storage/*/read",
      "Microsoft.Storage/storageAccounts/write",
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Insights/*",
    ]
    not_actions = [
      "Microsoft.Authorization/*/write",
      "Microsoft.Authorization/*/delete",
    ]
    data_actions     = []
    not_data_actions = []
  }

  assignable_scopes = var.custom_role_assignable_scopes
}

# ---------------------------------------------------------------------------
# Group-based RBAC: assign built-in/custom roles to Entra ID groups rather
# than to individual users, so access changes are a group-membership change,
# not a Terraform apply.
# ---------------------------------------------------------------------------

resource "azurerm_role_assignment" "admin" {
  for_each = toset(var.admin_group_object_ids)

  scope                = var.scope
  role_definition_name = "Owner"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "readonly" {
  for_each = toset(var.readonly_group_object_ids)

  scope                = var.scope
  role_definition_name = "Reader"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "operator" {
  for_each = toset(var.operator_group_object_ids)

  scope              = var.scope
  role_definition_id = azurerm_role_definition.operator.role_definition_resource_id
  principal_id       = each.value
}

# ---------------------------------------------------------------------------
# GitHub Actions OIDC federation: CI/CD authenticates as an Entra ID app
# registration via a workload identity federation credential — no client
# secret is ever generated, stored, or rotated.
# ---------------------------------------------------------------------------

resource "azuread_application" "github_actions" {
  count = var.enable_github_oidc ? 1 : 0

  display_name = "${var.name}-github-actions"
}

resource "azuread_service_principal" "github_actions" {
  count = var.enable_github_oidc ? 1 : 0

  client_id = azuread_application.github_actions[0].client_id
}

resource "azuread_application_federated_identity_credential" "github_actions" {
  count = var.enable_github_oidc ? 1 : 0

  application_id = azuread_application.github_actions[0].id
  display_name   = "github-actions-oidc"
  description    = "Federated credential for ${var.github_org}/${var.github_repo} GitHub Actions"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = var.github_oidc_allowed_subject
}

resource "azurerm_role_assignment" "github_actions" {
  for_each = var.enable_github_oidc ? toset(var.github_actions_role_definition_names) : toset([])

  scope                = var.scope
  role_definition_name = each.value
  principal_id         = azuread_service_principal.github_actions[0].object_id
}
