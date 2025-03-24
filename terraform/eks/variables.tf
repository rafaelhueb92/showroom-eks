variable "ssh_key_path" {
  description = "Path to the SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "subnet_ids" {
  description = "The subnets of the eks nodes"
}

variable "security_group_id" {
  description = "The SG of the eks"
}

variable "eks_role_arn" {
  description = "The role arn of the eks"
}

variable "ec2_role_arn" {
  description = "The role arn of the ec2 instances node"
}

variable "project_name" {
  description = "The name of the application"
}

variable "public_key" { 
  description = "Public key for the instance nodes"
}

variable "admin_arn" { 
  description = "Admin arn to entry into the cluster"
}