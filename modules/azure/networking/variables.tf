variable "name" {
  description = "Name prefix applied to every resource created by this module (e.g. \"lz-prod\")."
  type        = string
}

variable "location" {
  description = "Azure region, e.g. \"westeurope\"."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group the VNet and its subnets/NSGs are created in."
  type        = string
}

variable "address_space" {
  description = "Address space of the virtual network, e.g. [\"10.1.0.0/16\"]."
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnet name => configuration. Each subnet gets its own NSG."
  type = map(object({
    address_prefixes = list(string)
    # Free-form NSG rules layered on top of the default deny-inbound-internet baseline.
    extra_nsg_rules = optional(list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    })), [])
  }))
}

variable "enable_flow_logs" {
  description = "Whether to enable NSG flow logs (with traffic analytics) for every subnet's NSG."
  type        = bool
  default     = true
}

variable "network_watcher_name" {
  description = "Name of the Network Watcher flow logs are attached to. Required when enable_flow_logs is true."
  type        = string
  default     = ""
}

variable "network_watcher_resource_group_name" {
  description = "Resource group containing the Network Watcher. Required when enable_flow_logs is true."
  type        = string
  default     = ""
}

variable "flow_log_storage_account_id" {
  description = "Storage account ID flow logs are archived to. Typically the output of the logging module. Required when enable_flow_logs is true."
  type        = string
  default     = ""
}

variable "flow_log_retention_days" {
  description = "Number of days flow log blobs are retained in the storage account."
  type        = number
  default     = 90
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace resource ID for flow log traffic analytics. Typically the output of the logging module. Required when enable_flow_logs is true."
  type        = string
  default     = ""
}

variable "log_analytics_workspace_guid" {
  description = "Log Analytics workspace GUID (workspace ID, not resource ID) for flow log traffic analytics."
  type        = string
  default     = ""
}

variable "log_analytics_workspace_region" {
  description = "Region of the Log Analytics workspace used for traffic analytics."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags applied to every resource created by this module."
  type        = map(string)
  default     = {}
}
