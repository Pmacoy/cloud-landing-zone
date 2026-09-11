output "log_bucket_id" {
  description = "Name of the centralized S3 log archive bucket."
  value       = aws_s3_bucket.logs.id
}

output "log_bucket_arn" {
  description = "ARN of the centralized S3 log archive bucket."
  value       = aws_s3_bucket.logs.arn
}

output "cloudtrail_arn" {
  description = "ARN of the CloudTrail trail (null if enable_cloudtrail is false)."
  value       = try(aws_cloudtrail.this[0].arn, null)
}

output "flow_logs_log_group_arn" {
  description = "ARN of the CloudWatch Logs group VPC Flow Logs are delivered to."
  value       = aws_cloudwatch_log_group.flow_logs.arn
}

output "flow_logs_iam_role_arn" {
  description = "ARN of the IAM role the VPC Flow Logs service assumes to write to CloudWatch Logs."
  value       = aws_iam_role.flow_logs.arn
}
