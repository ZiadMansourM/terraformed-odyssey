resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "6.7.17"
  timeout    = 300
  atomic     = true
  create_namespace = true

  values = [
    file("${path.module}/files/argocd-values.yaml")
  ]
}

resource "kubectl_manifest" "root_app" {
  depends_on = [helm_release.argocd]
  
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind" = "Application"
    "metadata" = {
      "name" = "root-app"
      "namespace" = "argocd"
      "annotations" = {
        "argocd.argoproj.io/sync-wave" = "0"
        "notifications.argoproj.io/subscribe.on-deployed.slack" = "alerts"
        "notifications.argoproj.io/subscribe.on-sync-failed.slack" = "alerts"
        "notifications.argoproj.io/subscribe.on-sync-succeeded.slack" = "alerts"
      }
    }
    "spec" = {
      "project" = "default"
      "source" = {
        "repoURL" = "https://github.com/ZiadMansourM/terraformed-odyssey.git"
        "targetRevision" = "HEAD"
        "path" = "./argocd/root-app"
      }
      "destination" = {
        "server" = "https://kubernetes.default.svc"
        "namespace" = "argocd"
      }
      "syncPolicy" = {
        "automated" = {
          "prune" = true
          "selfHeal" = true
        }
      }
    }
  }
}
