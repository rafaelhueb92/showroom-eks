variable "project_name" {
  description = "The name of the application"
  default = "show-room-eks"
}

variable "aws_region" {
  description = "The aws region"
  default = "us-east-1"
}

variable "ROLE_ARN" { 
  description = "Admin arn to entry into the cluster"
}