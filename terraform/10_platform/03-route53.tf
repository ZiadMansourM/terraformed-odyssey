# Create a public hosted zone in Route53
resource "aws_route53_zone" "public" {
  name = "k8s.sreboy.com"
}

output "ns_records" {
  description = "The name servers for the public hosted zone"
  value       = aws_route53_zone.public.name_servers
}

data "kubernetes_service" "external_nginx_controller" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx-external"
  }

  depends_on = [
    helm_release.ingress-nginx-external
  ]
}

output "external_nginx_dns_lb" {
  description = "External DNS name for the NGINX Load Balancer."
  value = data.kubernetes_service.external_nginx_controller.status.0.load_balancer.0.ingress.0.hostname
}

resource "aws_route53_record" "wildcard_cname" {
  zone_id = aws_route53_zone.public.zone_id
  name = "*"
  type = "CNAME"
  ttl = "300"

  records = [
    data.kubernetes_service.external_nginx_controller.status.0.load_balancer.0.ingress.0.hostname
  ]
}

resource "aws_route53_zone" "private" {
  name = "k8s.sreboy.com"

  vpc {
    vpc_id = data.aws_eks_cluster.cluster.vpc_config.0.vpc_id
  }
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

output "internal_nginx_dns_lb" {
  description = "Internal DNS name for the NGINX Load Balancer."
  value = data.kubernetes_service.internal_nginx_controller.status.0.load_balancer.0.ingress.0.hostname
}

resource "aws_route53_record" "internal_wildcard_cname" {
  zone_id = aws_route53_zone.private.zone_id
  name = "*"
  type = "CNAME"
  ttl = "300"

  records = [
    data.kubernetes_service.internal_nginx_controller.status.0.load_balancer.0.ingress.0.hostname
  ]
}
