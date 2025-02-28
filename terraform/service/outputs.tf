output "eks_service_node_port" {
  value = kubernetes_service.eks_service.spec[0].port[0].node_port
}

output "eks_service_dns" {
  value = kubernetes_service.eks_service.status[0].load_balancer[0].ingress[0].hostname
}
