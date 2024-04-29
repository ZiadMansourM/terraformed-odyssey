# Resource: helm_release
# https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release

resource "helm_release" "ingress-nginx-external" {
  name       = "ingress-nginx-external"
  namespace  = "ingress-nginx-external"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.0.1"
  timeout    = 300
  atomic     = true
  create_namespace = true

  depends_on = [
    helm_release.kube_prometheus_stack
  ]

  values = [
    "${file("files/external-nginx-values.yaml")}"
  ]
}

resource "helm_release" "ingress-nginx-internal" {
  name       = "ingress-nginx-internal"
  namespace  = "ingress-nginx-internal"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.0.1"
  timeout    = 300
  atomic     = true
  create_namespace = true

  depends_on = [
    helm_release.kube_prometheus_stack
  ]

  values = [
    "${file("files/internal-nginx-values.yaml")}"
  ]
}
