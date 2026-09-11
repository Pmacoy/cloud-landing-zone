output "admin_role_arn" {
  description = "ARN of the break-glass admin role (null if no admin principals were configured)."
  value       = try(aws_iam_role.admin[0].arn, null)
}

output "readonly_role_arn" {
  description = "ARN of the read-only auditor role (null if no readonly principals were configured)."
  value       = try(aws_iam_role.readonly[0].arn, null)
}

output "github_actions_role_arn" {
  description = "ARN of the GitHub Actions OIDC role CI/CD assumes (null if enable_github_oidc is false)."
  value       = try(aws_iam_role.github_actions[0].arn, null)
}

output "github_oidc_provider_arn" {
  description = "ARN of the GitHub Actions OIDC provider (null if enable_github_oidc is false)."
  value       = try(aws_iam_openid_connect_provider.github[0].arn, null)
}
