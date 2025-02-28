resource "kubernetes_ingress_v1" "alb_ingress" {
  metadata {
    name      = "alb-ingress-${var.cluster_name}"
    namespace = "argocd"
    annotations = {
      "kubernetes.io/ingress.class"              = "alb"
      "alb.ingress.kubernetes.io/scheme"        = "internet-facing"
      "alb.ingress.kubernetes.io/load-balancer-name" = "alb-${var.cluster_name}"
    }
  }

  spec {
    rule {
      http {
        path {
          path = "/argocd"
          path_type = "Prefix"
          backend {
            service {
              name = "argocd-server"
              port {
                number = 80
              }
            }
          }
        }
        path {
          path = "/grafana"
          path_type = "Prefix"
          backend {
            service {
              name = "grafana"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
