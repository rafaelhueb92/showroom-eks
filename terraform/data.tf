data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "backend_bucket_name" {
  name = "/backend-tf/name"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/vpc/show-room-eks/id"
}

data "aws_security_group" "eks_sg" {
  filter {
    name   = "tag:Project"
    values = ["showroom-eks"]
  }
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_ssm_parameter.vpc_id.value]
  }
}