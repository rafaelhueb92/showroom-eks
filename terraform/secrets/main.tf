resource "aws_secretsmanager_secret" "this" {
  name        = "argocd-secret-${var.project_name}"
  description = "ArgoCD default user and password secret for project ${var.project_name}"
}

resource "aws_secretsmanager_secret_version" "argocd_secret_version" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = jsonencode({
    argocd_user     = "admin"       
    argocd_password = "default_pass" 
  })
}
