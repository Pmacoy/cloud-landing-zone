resource "azurerm_resource_group" "this" {
  name     = "${var.name}-rg"
  location = var.location
  tags     = var.tags
}

module "logging" {
  source = "../../modules/azure/logging"

  name                = var.name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  log_retention_days               = var.log_retention_days
  create_network_watcher           = var.create_network_watcher
  enable_subscription_activity_log = true

  tags = var.tags
}

module "networking" {
  source = "../../modules/azure/networking"

  name                = var.name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.address_space
  subnets             = var.subnets

  enable_flow_logs = var.enable_flow_logs

  # Wired to the logging module: flow logs land in the same storage
  # account / workspace as every other log source.
  network_watcher_name                = module.logging.network_watcher_name
  network_watcher_resource_group_name = module.logging.network_watcher_resource_group_name
  flow_log_storage_account_id         = module.logging.storage_account_id
  log_analytics_workspace_id          = module.logging.log_analytics_workspace_id
  log_analytics_workspace_guid        = module.logging.log_analytics_workspace_guid
  log_analytics_workspace_region      = var.location

  tags = var.tags
}

module "iam" {
  source = "../../modules/azure/iam"

  name                          = var.name
  scope                         = data.azurerm_subscription.current.id
  custom_role_assignable_scopes = [data.azurerm_subscription.current.id]

  admin_group_object_ids    = var.admin_group_object_ids
  readonly_group_object_ids = var.readonly_group_object_ids
  operator_group_object_ids = var.operator_group_object_ids

  enable_github_oidc                   = var.enable_github_oidc
  github_org                           = var.github_org
  github_repo                          = var.github_repo
  github_oidc_allowed_subject          = var.github_oidc_allowed_subject
  github_actions_role_definition_names = var.github_actions_role_definition_names
}
