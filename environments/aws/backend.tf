# Partial backend configuration on purpose: the bucket/key/table differ per
# environment (dev vs prod), so they're supplied at init time instead of
# hardcoded here. See envs/*.backend.hcl and the README "Remote state" section.
#
#   terraform init -backend-config=envs/dev.backend.hcl
#
# Bootstrap the bucket + DynamoDB lock table once per account with:
#   terraform -chdir=bootstrap/aws apply
terraform {
  backend "s3" {}
}
