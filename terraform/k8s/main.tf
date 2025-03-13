resource "null_resource" "this" {
  depends_on = [aws_eks_cluster.my_cluster]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.eks_cluster_name}"
  }
}

resource "kubernetes_config_map" "aws_auth" {
  
  depends_on = [null_resource.this]

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