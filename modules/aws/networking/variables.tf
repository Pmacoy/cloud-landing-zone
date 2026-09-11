variable "name" {
  description = "Name prefix applied to every resource created by this module (e.g. \"lz-prod\")."
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC, e.g. 10.0.0.0/16."
  type        = string
}

variable "availability_zones" {
  description = "Availability zones to spread subnets across, e.g. [\"eu-west-1a\", \"eu-west-1b\", \"eu-west-1c\"]."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "Provide at least two availability zones for a resilient landing zone."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets, one per availability zone, in the same order as availability_zones."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets, one per availability zone, in the same order as availability_zones."
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Whether private subnets get outbound internet access via NAT Gateway."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single shared NAT Gateway (cheaper, no cross-AZ resilience) instead of one per AZ."
  type        = bool
  default     = false
}

variable "flow_logs_log_group_arn" {
  description = "CloudWatch Logs group ARN that VPC Flow Logs are delivered to. Typically the output of the logging module."
  type        = string
}

variable "flow_logs_iam_role_arn" {
  description = "IAM role ARN that the VPC Flow Logs service assumes to write to CloudWatch Logs. Typically the output of the logging module."
  type        = string
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
