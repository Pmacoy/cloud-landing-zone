variable "name" {
  description = "Name prefix applied to every resource created by this module (e.g. \"lz-prod\")."
  type        = string
}

variable "scope" {
  description = "Scope RBAC role assignments apply to, e.g. a subscription ID (\"/subscriptions/...\") or a resource group ID."
  type        = string
}

variable "custom_role_name" {
  description = "Name of the custom landing-zone RBAC role (least-privilege alternative to built-in Contributor)."
  type        = string
  default     = "Landing Zone Operator"
}

variable "custom_role_assignable_scopes" {
  description = "Scopes the custom role definition can be assigned within. Usually the subscription ID."
  type        = list(string)
}

variable "admin_group_object_ids" {
  description = "Entra ID (Azure AD) group object IDs granted the built-in Owner role at var.scope."
  type        = list(string)
  default     = []
}

variable "readonly_group_object_ids" {
  description = "Entra ID (Azure AD) group object IDs granted the built-in Reader role at var.scope."
  type        = list(string)
  default     = []
}

variable "operator_group_object_ids" {
  description = "Entra ID (Azure AD) group object IDs granted the custom landing-zone operator role at var.scope."
  type        = list(string)
  default     = []
}

variable "enable_github_oidc" {
  description = "Whether to create an Entra ID app registration + federated identity credential for GitHub Actions (secret-less CI/CD deploys)."
  type        = bool
  default     = false
}

variable "github_org" {
  description = "GitHub organization or user that owns the repository allowed to federate. Required when enable_github_oidc is true."
  type        = string
  default     = ""
}

variable "github_repo" {
  description = "GitHub repository (without the org prefix) allowed to federate. Required when enable_github_oidc is true."
  type        = string
  default     = ""
}

variable "github_oidc_allowed_subject" {
  description = "Federated subject claim GitHub Actions must present, e.g. \"repo:org/repo:ref:refs/heads/main\"."
  type        = string
  default     = ""
}

variable "github_actions_role_definition_names" {
  description = "Built-in or custom role definition names assigned to the GitHub Actions service principal at var.scope."
  type        = list(string)
  default     = ["Reader"]
}
