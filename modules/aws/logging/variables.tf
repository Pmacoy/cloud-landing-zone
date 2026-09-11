variable "name" {
  description = "Name prefix applied to every resource created by this module (e.g. \"lz-prod\")."
  type        = string
}

variable "account_id" {
  description = "AWS account ID that owns the resources (used to build the CloudTrail bucket policy)."
  type        = string
}

variable "region" {
  description = "AWS region CloudTrail and the bucket policy are scoped to."
  type        = string
}

variable "log_retention_days" {
  description = "Number of days CloudWatch Logs and the S3 log archive keep data before expiring it."
  type        = number
  default     = 365
}

variable "noncurrent_version_retention_days" {
  description = "Number of days to keep noncurrent S3 object versions before permanent deletion."
  type        = number
  default     = 90
}

variable "enable_cloudtrail" {
  description = "Whether to create an account-level, multi-region CloudTrail trail writing to the centralized log bucket."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
