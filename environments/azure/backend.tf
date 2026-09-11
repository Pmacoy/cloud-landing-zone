# Partial backend configuration; supplied at init time so dev/prod use
# different storage containers. See envs/*.backend.hcl and the README.
#
#   terraform init -backend-config=envs/dev.backend.hcl
#
# Bootstrap the storage account + containers once per subscription with:
#   terraform -chdir=bootstrap/azure apply
terraform {
  backend "azurerm" {}
}
