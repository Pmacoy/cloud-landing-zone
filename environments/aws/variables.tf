variable "name" {
  description = "Name prefix applied to every resource in this environment, e.g. \"lz-dev\" or \"lz-prod\"."
  type        = string
}

variable "region" {
  description = "AWS region to deploy into, e.g. \"eu-west-1\"."
  type        = string
}

# --- Networking -------------------------------------------------------------

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones to spread subnets across."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets, one per AZ, matching availability_zones order."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets, one per AZ, matching availability_zones order."
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Whether private subnets get outbound internet access via NAT Gateway."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use one shared NAT Gateway instead of one per AZ. Cheaper; use for dev, avoid for prod."
  type        = bool
  default     = false
}

# --- Logging -----------------------------------------------------------------

variable "log_retention_days" {
  description = "Retention for CloudTrail/VPC Flow Logs and the S3 log archive."
  type        = number
  default     = 365
}

variable "enable_cloudtrail" {
  description = "Whether to create an account-level, multi-region CloudTrail trail."
  type        = bool
  default     = true
}

# --- IAM ----------------------------------------------------------------------

variable "human_admin_principal_arns" {
  description = "IAM principal ARNs allowed to assume the break-glass admin role."
  type        = list(string)
  default     = []
}

variable "readonly_principal_arns" {
  description = "IAM principal ARNs allowed to assume the read-only auditor role."
  type        = list(string)
  default     = []
}

variable "enable_github_oidc" {
  description = "Whether to set up OIDC federation for GitHub Actions CI/CD (no long-lived access keys)."
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

variable "github_oidc_allowed_ref" {
  description = "Git ref allowed to assume the CI/CD role, e.g. \"ref:refs/heads/main\"."
  type        = string
  default     = "ref:refs/heads/main"
}

variable "github_actions_policy_arns" {
  description = "IAM managed policy ARNs attached to the GitHub Actions role."
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
}

# --- Tagging -------------------------------------------------------------------

variable "tags" {
  description = "Tags applied to every resource in this environment."
  type        = map(string)
  default     = {}
}
