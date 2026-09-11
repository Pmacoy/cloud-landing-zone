variable "name" {
  description = "Name prefix applied to every resource in this environment, e.g. \"lz-dev\" or \"lz-prod\"."
  type        = string
}

variable "location" {
  description = "Azure region to deploy into, e.g. \"westeurope\"."
  type        = string
}

# --- Networking -------------------------------------------------------------

variable "address_space" {
  description = "Address space of the virtual network."
  type        = list(string)
  default     = ["10.2.0.0/16"]
}

variable "subnets" {
  description = "Map of subnet name => CIDR list. Each gets its own NSG (see modules/azure/networking)."
  type = map(object({
    address_prefixes = list(string)
  }))
  default = {
    public = {
      address_prefixes = ["10.2.0.0/24"]
    }
    private = {
      address_prefixes = ["10.2.10.0/24"]
    }
  }
}

variable "enable_flow_logs" {
  description = "Whether to enable NSG flow logs with traffic analytics."
  type        = bool
  default     = true
}

# --- Logging ------------------------------------------------------------------

variable "log_retention_days" {
  description = "Retention for the Log Analytics workspace and flow-log storage."
  type        = number
  default     = 90
}

variable "create_network_watcher" {
  description = "Whether to create a dedicated Network Watcher. Set false if the subscription already auto-manages one."
  type        = bool
  default     = true
}

# --- IAM ------------------------------------------------------------------------

variable "admin_group_object_ids" {
  description = "Entra ID group object IDs granted Owner at the subscription scope."
  type        = list(string)
  default     = []
}

variable "readonly_group_object_ids" {
  description = "Entra ID group object IDs granted Reader at the subscription scope."
  type        = list(string)
  default     = []
}

variable "operator_group_object_ids" {
  description = "Entra ID group object IDs granted the custom landing-zone operator role."
  type        = list(string)
  default     = []
}

variable "enable_github_oidc" {
  description = "Whether to set up workload identity federation for GitHub Actions CI/CD (no client secrets)."
  type        = bool
  default     = false
}

variable "github_org" {
  description = "GitHub organization or user. Required when enable_github_oidc is true."
  type        = string
  default     = ""
}

variable "github_repo" {
  description = "GitHub repository name. Required when enable_github_oidc is true."
  type        = string
  default     = ""
}

variable "github_oidc_allowed_subject" {
  description = "Federated subject claim GitHub Actions must present, e.g. \"repo:org/repo:ref:refs/heads/main\"."
  type        = string
  default     = ""
}

variable "github_actions_role_definition_names" {
  description = "Role definition names assigned to the GitHub Actions service principal."
  type        = list(string)
  default     = ["Reader"]
}

# --- Tagging ---------------------------------------------------------------------

variable "tags" {
  description = "Tags applied to every resource in this environment."
  type        = map(string)
  default     = {}
}
