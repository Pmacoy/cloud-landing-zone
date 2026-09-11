output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnet_ids" {
  value = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.networking.private_subnet_ids
}

output "log_bucket_id" {
  value = module.logging.log_bucket_id
}

output "cloudtrail_arn" {
  value = module.logging.cloudtrail_arn
}

output "github_actions_role_arn" {
  value = module.iam.github_actions_role_arn
}

output "admin_role_arn" {
  value = module.iam.admin_role_arn
}
