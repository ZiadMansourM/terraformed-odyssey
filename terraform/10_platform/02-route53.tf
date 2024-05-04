# Create a public hosted zone in Route53
resource "aws_route53_zone" "public" {
  name = "k8s.sreboy.com"
}

resource "aws_route53_record" "wildcard_cname" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "*"
  type    = "CNAME"
  ttl     = "300"

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

resource "aws_route53_record" "internal_wildcard_cname" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "*"
  type    = "CNAME"
  ttl     = "300"

  records = [
    data.kubernetes_service.internal_nginx_controller.status.0.load_balancer.0.ingress.0.hostname
  ]
}
