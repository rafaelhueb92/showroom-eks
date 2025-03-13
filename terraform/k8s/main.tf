resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<YAML
- rolearn: ${var.ROLE_ARN}
  username: github-actions
  groups:
    - system:masters
YAML
  }
}