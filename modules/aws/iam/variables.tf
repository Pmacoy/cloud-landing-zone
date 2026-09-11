variable "name" {
  description = "Name prefix applied to every resource created by this module (e.g. \"lz-prod\")."
  type        = string
}

variable "enable_github_oidc" {
  description = "Whether to create an OIDC identity provider + role for GitHub Actions (secret-less CI/CD deploys)."
  type        = bool
  default     = false
}

variable "github_org" {
  description = "GitHub organization or user that owns the repository allowed to assume the CI/CD role. Required when enable_github_oidc is true."
  type        = string
  default     = ""
}

variable "github_repo" {
  description = "GitHub repository (without the org prefix) allowed to assume the CI/CD role. Required when enable_github_oidc is true."
  type        = string
  default     = ""
}

variable "github_oidc_allowed_ref" {
  description = "Git ref allowed to assume the CI/CD role, e.g. \"ref:refs/heads/main\". Use \"*\" to allow any branch (not recommended for prod)."
  type        = string
  default     = "ref:refs/heads/main"
}

variable "github_actions_policy_arns" {
  description = "IAM managed policy ARNs attached to the GitHub Actions CI/CD role. Defaults to read-only; widen deliberately per environment."
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
}

variable "human_admin_principal_arns" {
  description = "IAM principal ARNs (users, SSO roles, other account roles) allowed to assume the break-glass admin role via sts:AssumeRole."
  type        = list(string)
  default     = []
}

variable "readonly_principal_arns" {
  description = "IAM principal ARNs allowed to assume the read-only auditor role."
  type        = list(string)
  default     = []
}

variable "enforce_iam_password_policy" {
  description = "Whether to enforce an account-wide IAM user password policy (CIS AWS Foundations 1.x)."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to every resource created by this module (roles only; IAM tags are limited but supported)."
  type        = map(string)
  default     = {}
}
