data "aws_caller_identity" "current" {
  
}

locals {
  principal_arns = var.principal_arns != null ? var.principal_arns: [data.aws_caller_identity.arn]
}

resource "aws_iam_role" "iam_role" {
  name = "${local.namespace}-tf-assume-role"

  assume_role_policy = <<- EOF 
  {
    "Version": "2012-10-17"

  }
  EOF
}