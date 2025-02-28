variable "project_name" {
  description = "The name of the application"
}
variable "subnet_ids" {
  description = "Subnets IDs in the VPC"
}

variable "vpc_id" {
  description = "The VPC Id"
}
variable "eks_service_dns" {
  description = "The Ip of the service"
}