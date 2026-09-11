name   = "lz-dev"
region = "eu-west-1"

availability_zones   = ["eu-west-1a", "eu-west-1b"]
vpc_cidr_block       = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]

enable_nat_gateway = true
single_nat_gateway = true

log_retention_days = 90
enable_cloudtrail  = true

human_admin_principal_arns = []
readonly_principal_arns    = []
enable_github_oidc         = false

tags = {
  Project     = "cloud-landing-zone"
  Environment = "dev"
  ManagedBy   = "terraform"
}
