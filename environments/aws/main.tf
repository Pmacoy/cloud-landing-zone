module "logging" {
  source = "../../modules/aws/logging"

  name       = var.name
  account_id = data.aws_caller_identity.current.account_id
  region     = var.region

  log_retention_days = var.log_retention_days
  enable_cloudtrail  = var.enable_cloudtrail

  tags = var.tags
}

module "networking" {
  source = "../../modules/aws/networking"

  name                 = var.name
  vpc_cidr_block       = var.vpc_cidr_block
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway

  # Wired to the logging module so flow logs land in the centralized account.
  flow_logs_log_group_arn = module.logging.flow_logs_log_group_arn
  flow_logs_iam_role_arn  = module.logging.flow_logs_iam_role_arn

  tags = var.tags
}

module "iam" {
  source = "../../modules/aws/iam"

  name = var.name

  human_admin_principal_arns = var.human_admin_principal_arns
  readonly_principal_arns    = var.readonly_principal_arns

  enable_github_oidc         = var.enable_github_oidc
  github_org                 = var.github_org
  github_repo                = var.github_repo
  github_oidc_allowed_ref    = var.github_oidc_allowed_ref
  github_actions_policy_arns = var.github_actions_policy_arns

  tags = var.tags
}
