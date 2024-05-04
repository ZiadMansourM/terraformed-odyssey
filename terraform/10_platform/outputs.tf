output "internal_nginx_dns_lb" {
  description = "Internal DNS name for the NGINX Load Balancer."
  value       = data.kubernetes_service.internal_nginx_controller.status.0.load_balancer.0.ingress.0.hostname
}

output "ns_records" {
  description = "The name servers for the public hosted zone"
  value       = aws_route53_zone.public.name_servers
}

output "external_nginx_dns_lb" {
  description = "External DNS name for the NGINX Load Balancer."
  value       = data.kubernetes_service.external_nginx_controller.status.0.load_balancer.0.ingress.0.hostname
}

output "issuer_url_oidc" {
  description = "Issuer URL for the OpenID Connect identity provider."
  value       = data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

output "issuer_url_oidc_replaced" {
  description = "Issuer URL for the OpenID Connect identity provider without https://."
  value       = replace(data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer, "https://", "")
}
