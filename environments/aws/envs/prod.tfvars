name   = "lz-prod"
region = "eu-west-1"

availability_zones   = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
vpc_cidr_block       = "10.1.0.0/16"
public_subnet_cidrs  = ["10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.10.0/24", "10.1.11.0/24", "10.1.12.0/24"]

enable_nat_gateway = true
single_nat_gateway = false # one NAT Gateway per AZ for real resilience

log_retention_days = 400
enable_cloudtrail  = true

# Populate before applying to a real prod account.
human_admin_principal_arns = []
readonly_principal_arns    = []
enable_github_oidc         = false

tags = {
  Project     = "cloud-landing-zone"
  Environment = "prod"
  ManagedBy   = "terraform"
}
