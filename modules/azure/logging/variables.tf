variable "name" {
  description = "Name prefix applied to every resource created by this module (e.g. \"lz-prod\")."
  type        = string
}

variable "location" {
  description = "Azure region, e.g. \"westeurope\"."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group the logging resources are created in."
  type        = string
}

variable "log_retention_days" {
  description = "Number of days the Log Analytics workspace and diagnostic storage retain data."
  type        = number
  default     = 90
}

variable "create_network_watcher" {
  description = "Whether to create a Network Watcher in this resource group/region. Set to false if the subscription already has one auto-managed by Azure (common in the default \"NetworkWatcherRG\"), and supply existing_network_watcher_name/resource_group instead."
  type        = bool
  default     = true
}

variable "existing_network_watcher_name" {
  description = "Name of an existing Network Watcher to use when create_network_watcher is false."
  type        = string
  default     = ""
}

variable "existing_network_watcher_resource_group_name" {
  description = "Resource group of an existing Network Watcher to use when create_network_watcher is false."
  type        = string
  default     = ""
}

variable "enable_subscription_activity_log" {
  description = "Whether to stream the subscription Activity Log (control-plane audit trail) into the Log Analytics workspace."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
