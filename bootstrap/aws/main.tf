# One-time bootstrap: creates the S3 bucket + DynamoDB lock table that the
# real environments/aws state backend depends on. Deliberately kept on a
# local backend (no chicken-and-egg problem) and applied once per AWS account,
# before `terraform init` is ever run in environments/aws.
#
#   terraform -chdir=bootstrap/aws init
#   terraform -chdir=bootstrap/aws apply -var="name_prefix=lz"

terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40, < 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "state" {
  for_each = toset(var.environments)

  bucket = "${var.name_prefix}-tfstate-${each.value}-${data.aws_caller_identity.current.account_id}"

  tags = {
    Purpose = "terraform-remote-state"
  }
}

resource "aws_s3_bucket_versioning" "state" {
  for_each = aws_s3_bucket.state

  bucket = each.value.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  for_each = aws_s3_bucket.state

  bucket = each.value.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "state" {
  for_each = aws_s3_bucket.state

  bucket                  = each.value.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "lock" {
  for_each = toset(var.environments)

  name         = "${var.name_prefix}-tfstate-lock-${each.value}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Purpose = "terraform-state-locking"
  }
}
