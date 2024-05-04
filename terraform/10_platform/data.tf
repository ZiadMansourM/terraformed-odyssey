data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

# Data Source: aws_caller_identity
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
data "aws_caller_identity" "current" {}

data "kubernetes_service" "external_nginx_controller" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx-external"
  }

  depends_on = [
    helm_release.ingress-nginx-external
  ]
}

data "kubernetes_service" "internal_nginx_controller" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx-internal"
  }

  depends_on = [
    helm_release.ingress-nginx-internal
  ]
}

data "tls_certificate" "demo" {
  url = data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}
