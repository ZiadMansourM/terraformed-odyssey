# Deploy Argocd helm chart with the following:
# - I am using app-of-apps pattern to deploy the argocd applications
# - Source Repository: https://github.com/ZiadMansourM/terraformed-odyssey
# - Path to Root ArgoCD Application: terraformed-odyssey/arogcd/root-app/

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "3.12.3"
  timeout    = 300
  atomic     = true
  create_namespace = true

  values = [
    <<YAML
repositories:
  root-repo:
    url: https://github.com/ZiadMansourM/terraformed-odyssey
    type: git
    YAML
  ]
}