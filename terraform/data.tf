data "aws_caller_identity" "current" {}

data "account_id" {
  value = data.aws_caller_identity.current.account_id
}

data "aws_ssm_parameter" "backend_bucket_name" {
  name = "/backend-tf/name"
}