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

module "eks" {

  source = "./eks"

  project_name = var.project_name
  subnet_ids = data.aws_subnets.this.value
  security_group_id = data.aws_security_group.eks_sg.value
  eks_role_arn = module.iam.eks_role_arn
  ec2_role_arn = module.iam.ec2_role_arn
  public_key = module.ssh_key.public_key

  depends_on = [
    module.vpc,module.iam,module.ssh_key
  ]

}

module "k8s" {

  source = "./k8s"

  ROLE_ARN = var.ROLE_ARN
  eks_cluster_name = module.eks.eks_cluster_name
  aws_region = var.aws_region

  depends_on = [
    module.eks
  ]

}