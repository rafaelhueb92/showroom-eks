resource "helm_release" "alb_controller" {
  name       = "aws-load-balancer-controller-${var.project_name}"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }
}

resource "helm_release" "prometheus_grafana" {
  name       = "monitoring"
  namespace  = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "45.0.0"

  create_namespace = true

  set {
    name  = "grafana.enabled"
    value = "true"
  }

  set {
    name  = "prometheus.enabled"
    value = "true"
  }

  values = [
    # Use the local value to inject secret dynamically into the Helm chart values file
    templatefile("${path.module}/prometheus_grafana_values.yaml", {
      grafana_admin_password = data.aws_secretsmanager_secret_version.grafana_admin_password.secret_string
    })
  ]

}

resource "kubernetes_config_map" "grafana_datasource" {
  metadata {
    name      = "grafana-datasource"
    namespace = "monitoring"
    labels = {
      grafana_datasource = "1"
    }
  }

  data = {
    prometheus.yaml = <<-EOT
      apiVersion: 1
      datasources:
        - name: Prometheus
          type: prometheus
          url: http://monitoring-prometheus.monitoring.svc.cluster.local:9090
          access: proxy
          isDefault: true
    EOT
  }
}

resource "helm_release" "argocd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  create_namespace = true
}
