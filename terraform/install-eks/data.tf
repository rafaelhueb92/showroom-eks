data "aws_eks_cluster" "eks" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = var.cluster_name
}

data "aws_secretsmanager_secret" "grafana_admin_password" {
  name = "grafana-admin-password-${var.project_name}"
}

data "aws_secretsmanager_secret_version" "grafana_admin_password" {
  secret_id = data.aws_secretsmanager_secret.grafana_admin_password.id
}
