resource "helm_release" "trivy" {
  name             = "trivy-operator"
  namespace        = "trivy-operator"
  repository       = "https://bitnami-labs.github.io/sealed-secrets"
  chart            = "trivy-operator"
  version          = "0.22.1"
  timeout          = 300
  atomic           = true
  create_namespace = true
}
