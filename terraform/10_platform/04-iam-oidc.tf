output "issuer_url_oidc" {
  description = "Issuer URL for the OpenID Connect identity provider."
  value       = data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

output "issuer_url_oidc_replaced" {
  description = "Issuer URL for the OpenID Connect identity provider without https://."
  value       = replace(data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer, "https://", "")
}

data "tls_certificate" "demo" {
  url = data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  url             = data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.demo.certificates[0].sha1_fingerprint]
}
