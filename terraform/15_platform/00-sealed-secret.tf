resource "helm_release" "sealed_secrets" {
  name       = "sealed-secrets"
  namespace  = "sealed-secrets"
  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart      = "sealed-secrets"
  version    = "2.15.3"
  timeout    = 300
  atomic     = true
  create_namespace = true
}
