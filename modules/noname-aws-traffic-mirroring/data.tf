##################################
# data about current environment #
##################################

data "aws_caller_identity" "current" {}
data "aws_region" "current_region" {}
data "aws_iam_account_alias" "current_alias" {}

data "aws_vpc" "target" {
  default = "false"
  state   = "available"

  tags = {
    Terraform = "AccountVPC"
  }
}