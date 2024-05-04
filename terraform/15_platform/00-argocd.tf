resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "6.7.17"
  timeout          = 300
  atomic           = true
  create_namespace = true

  values = [
    file("${path.module}/files/argocd-values.yaml")
  ]
}

resource "kubectl_manifest" "root_app" {
  depends_on = [helm_release.argocd]
  yaml_body  = file("${path.module}/../../argocd/root-app/root-app.yaml")
}
