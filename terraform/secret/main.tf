resource "aws_secretsmanager_secret" "grafana_admin_password" {
  name        = "grafana-admin-password-${var.project_name}"
  description = "Grafana Admin Password"
}

resource "aws_secretsmanager_secret_version" "grafana_admin_password_version" {
  secret_id     = aws_secretsmanager_secret.grafana_admin_password.id
  secret_string = jsonencode({
    username = "admin"
    password = var.grafana_password
  })
}
