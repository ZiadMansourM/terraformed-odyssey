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
