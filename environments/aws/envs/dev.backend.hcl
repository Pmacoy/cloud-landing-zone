bucket         = "lz-tfstate-dev-REPLACE_WITH_ACCOUNT_ID"
key            = "aws/dev/terraform.tfstate"
region         = "eu-west-1"
dynamodb_table = "lz-tfstate-lock-dev"
encrypt        = true
