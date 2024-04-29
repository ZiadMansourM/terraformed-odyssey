resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "6.7.17"
  timeout    = 300
  atomic     = true
  create_namespace = true

  # configs:
  #   params:
  #     server.insecure: true

  set {
    name = "configs.params.server\\.insecure"
    value = "true"
  }

  # server:
  # metrics:
  #   enabled: true
  #   serviceMonitor:
  #     enabled: true

  set {
    name  = "server.metrics.enabled"
    value = "true"
  }

  set {
    name  = "server.metrics.serviceMonitor.enabled"
    value = "true"
  }
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
      }
      "finalizers" = [
        "resources-finalizer.argocd.argoproj.io"
      ]
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
