# Resource: helm_release
# https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release

resource "helm_release" "kube_prometheus_stack" {
  name             = "monitoring"
  namespace        = "monitoring"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "58.1.3"
  timeout          = 300
  atomic           = true
  create_namespace = true

  values = [
    "${file("files/kube-prometheus-stack-values.yaml")}"
  ]
}

resource "helm_release" "loki-distributed" {
  name = "loki"
  namespace = "monitoring"
  repository = "https://grafana.github.io/helm-charts"
  chart = "loki-distributed"
  version = "0.79.0"
  timeout = 300
  atomic = true
  create_namespace = true

  values = [
    "${file("files/loki-distributed-values.yaml")}"
  ]

  depends_on = [helm_release.kube_prometheus_stack]
}

resource "helm_release" "promtail" {
  name = "promtail"
  namespace = "monitoring"
  repository = "https://grafana.github.io/helm-charts"
  chart = "promtail"
  version = "6.15.5"
  timeout = 300
  atomic = true
  create_namespace = true

  values = [
    "${file("files/promtail-values.yaml")}"
  ]
}
