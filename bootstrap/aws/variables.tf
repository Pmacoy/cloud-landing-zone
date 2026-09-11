variable "region" {
  description = "AWS region the state bucket(s) and lock table(s) are created in."
  type        = string
  default     = "eu-west-1"
}

variable "name_prefix" {
  description = "Prefix used for bucket and table names, must match environments/aws/envs/*.backend.hcl."
  type        = string
  default     = "lz"
}

variable "environments" {
  description = "Environment names to create a state bucket + lock table for."
  type        = list(string)
  default     = ["dev", "prod"]
}
