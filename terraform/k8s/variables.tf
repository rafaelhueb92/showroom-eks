variable "ROLE_ARN" {
  description = "github actions role arn"
}

variable "eks_cluster_name" { 
  description = "The EKS Cluster Name"
}

variable "aws_region" {
  description = "The aws region"
  default = "us-east-1"
}