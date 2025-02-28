provider "aws" {
  region = "us-east-1"

  # Default tags for all resources
  default_tags {
    tags = {
      Environment = "dev"
      Project     = "showroom-eks"
    }
  }
}

module "vpc" { 
  source = "./vpc"
  project_name = var.project_name
}

module "iam" { 
  source = "./iam"
  project_name = var.project_name
}

module "secret" { 
  source = "./secret"
  project_name = var.project_name
}

module "eks" {

  source = "./eks"

  project_name = var.project_name
  subnet_ids = module.vpc.subnet_ids
  security_group_id = module.vpc.security_groups
  eks_role_arn = module.iam.eks_role_arn

  depends_on = [
    module.vpc,module.iam
  ]

}