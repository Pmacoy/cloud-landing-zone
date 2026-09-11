bucket         = "lz-tfstate-prod-REPLACE_WITH_ACCOUNT_ID"
key            = "aws/prod/terraform.tfstate"
region         = "eu-west-1"
dynamodb_table = "lz-tfstate-lock-prod"
encrypt        = true
