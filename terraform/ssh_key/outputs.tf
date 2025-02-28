output "public_key" {
  description = "The generated SSH public key"
  value       = aws_ssm_parameter.public_key.value
}

output "private_key_ssm_arn" {
  description = "The ARN of the private key stored in SSM"
  value       = aws_ssm_parameter.private_key.arn
}
