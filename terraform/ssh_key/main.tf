resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_ssm_parameter" "private_key" {
  name        = "/ssh_keys/${var.project_name}"
  description = "SSH private key for ${var.project_name}"
  type        = "SecureString"
  value       = tls_private_key.ssh.private_key_pem

  tags = {
    Name = var.project_name
  }
}

resource "aws_ssm_parameter" "public_key" {
  name        = "/ssh_keys/${var.project_name}_pub"
  description = "SSH public key for ${var.project_name}"
  type        = "String"
  value       = tls_private_key.ssh.public_key_openssh

  tags = {
    Name = "${var.project_name}_pub"
  }
}
