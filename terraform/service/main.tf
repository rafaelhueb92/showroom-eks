provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  token                  = data.aws_eks_cluster_auth.eks.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
}

resource "kubernetes_service" "eks_service" {
  metadata {
    name      = "${var.project_name}-app-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "${var.project_name}-app-service"
    }

    port {
      port        = 80
      target_port = 8080
      protocol    = "TCP"
    }

    type = "NodePort" 
  }
}
