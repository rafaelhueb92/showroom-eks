output "alb_dns" {
  description = "ALB DNS Name"
  value       = kubernetes_ingress_v1.alb_ingress.status[0].load_balancer[0].ingress[0].hostname
}
