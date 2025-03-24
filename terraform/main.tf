provider "aws" {
  region = var.aws_region

  # Default tags for all resources
  default_tags {
    tags = {
      Environment = "dev"
      Project     = "showroom-eks"
    }
  }
}

module "iam" { 
  source = "./iam"
  project_name = var.project_name
}

module "ssh_key" { 
  source = "./ssh_key"
  project_name = var.project_name
}

module "acm" {
  source = "./acm"
  project_name = var.project_name
}

module "secrets" {
  source ="./secrets"
  project_name = var.project_name
}

module "eks" {

  source = "./eks"

  project_name = var.project_name
  subnet_ids = data.aws_subnets.this.ids
  security_group_id = data.aws_security_group.eks_sg.id
  eks_role_arn = module.iam.eks_role_arn
  ec2_role_arn = module.iam.ec2_role_arn
  public_key = module.ssh_key.public_key
  admin_arn = var.ROLE_ARN

  depends_on = [
    module.iam,module.ssh_key
  ]

}