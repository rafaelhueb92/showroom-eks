output "eks_cluster_name" {
    value = module.eks.eks_cluster_name
}

output "project_name" {
  value = var.project_name
}

output "certificate_arn" {
  value = module.acm.certificate_arn
}

output "secret_arn" {
  value = module.secrets.secret_arn
}
