output "state_buckets" {
  value = { for env, b in aws_s3_bucket.state : env => b.id }
}

output "lock_tables" {
  value = { for env, t in aws_dynamodb_table.lock : env => t.name }
}
