name     = "lz-prod"
location = "westeurope"

address_space = ["10.3.0.0/16"]
subnets = {
  public = {
    address_prefixes = ["10.3.0.0/24"]
  }
  private = {
    address_prefixes = ["10.3.10.0/24"]
  }
}

enable_flow_logs       = true
create_network_watcher = true
log_retention_days     = 365

# Populate before applying to a real prod subscription.
admin_group_object_ids    = []
readonly_group_object_ids = []
operator_group_object_ids = []
enable_github_oidc        = false

tags = {
  Project     = "cloud-landing-zone"
  Environment = "prod"
  ManagedBy   = "terraform"
}
