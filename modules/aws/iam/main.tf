locals {
  common_tags = merge(var.tags, { "landing-zone:module" = "aws/iam" })
}

# ---------------------------------------------------------------------------
# Break-glass admin role: full access, but only reachable via AssumeRole from
# a short, explicit allow-list of trusted principals (SSO roles, other
# accounts) — never a long-lived IAM user with AdministratorAccess attached.
# ---------------------------------------------------------------------------

data "aws_iam_policy_document" "admin_assume" {
  count = length(var.human_admin_principal_arns) > 0 ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.human_admin_principal_arns
    }
  }
}

resource "aws_iam_role" "admin" {
  count = length(var.human_admin_principal_arns) > 0 ? 1 : 0

  name                 = "${var.name}-admin"
  assume_role_policy   = data.aws_iam_policy_document.admin_assume[0].json
  max_session_duration = 3600

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "admin" {
  count = length(var.human_admin_principal_arns) > 0 ? 1 : 0

  role       = aws_iam_role.admin[0].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# ---------------------------------------------------------------------------
# Read-only auditor role for humans who need visibility without write access.
# ---------------------------------------------------------------------------

data "aws_iam_policy_document" "readonly_assume" {
  count = length(var.readonly_principal_arns) > 0 ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.readonly_principal_arns
    }
  }
}

resource "aws_iam_role" "readonly" {
  count = length(var.readonly_principal_arns) > 0 ? 1 : 0

  name                 = "${var.name}-readonly"
  assume_role_policy   = data.aws_iam_policy_document.readonly_assume[0].json
  max_session_duration = 3600

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "readonly" {
  count = length(var.readonly_principal_arns) > 0 ? 1 : 0

  role       = aws_iam_role.readonly[0].name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# ---------------------------------------------------------------------------
# GitHub Actions OIDC: lets CI/CD assume a scoped role without ever storing
# an AWS access key as a repository secret.
# ---------------------------------------------------------------------------

resource "aws_iam_openid_connect_provider" "github" {
  count = var.enable_github_oidc ? 1 : 0

  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  # GitHub's OIDC token is now validated by AWS against client_id rather than
  # this thumbprint, but the attribute is still required by the provider.
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]

  tags = local.common_tags
}

data "aws_iam_policy_document" "github_actions_assume" {
  count = var.enable_github_oidc ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github[0].arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_org}/${var.github_repo}:${var.github_oidc_allowed_ref}"]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  count = var.enable_github_oidc ? 1 : 0

  name               = "${var.name}-github-actions"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume[0].json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "github_actions" {
  for_each = var.enable_github_oidc ? toset(var.github_actions_policy_arns) : toset([])

  role       = aws_iam_role.github_actions[0].name
  policy_arn = each.value
}

# ---------------------------------------------------------------------------
# Account-wide IAM password policy (CIS AWS Foundations Benchmark 1.x)
# ---------------------------------------------------------------------------

resource "aws_iam_account_password_policy" "this" {
  count = var.enforce_iam_password_policy ? 1 : 0

  minimum_password_length        = 14
  require_lowercase_characters   = true
  require_uppercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  max_password_age               = 90
  password_reuse_prevention      = 24
}
