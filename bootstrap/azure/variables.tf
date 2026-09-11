variable "location" {
  description = "Azure region the bootstrap resource group and storage account are created in."
  type        = string
  default     = "westeurope"
}

variable "name_prefix" {
  description = "Prefix used for the resource group / storage account names."
  type        = string
  default     = "lz"
}

variable "environments" {
  description = "Environment names to create a state container for."
  type        = list(string)
  default     = ["dev", "prod"]
}
