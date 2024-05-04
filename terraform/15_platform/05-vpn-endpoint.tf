resource "aws_ec2_client_vpn_endpoint" "this" {
  server_certificate_arn = aws_acm_certificate.this.arn
  client_cidr_block      = "172.16.0.0/22"

  description           = "${var.cluster_name} Client VPN"
  vpc_id                = data.aws_eks_cluster.cluster.vpc_config.0.vpc_id
  session_timeout_hours = 8
  split_tunnel          = true
  self_service_portal   = "enabled"
  transport_protocol    = "udp"
  security_group_ids    = [aws_security_group.this.id]
  dns_servers           = [cidrhost(data.aws_vpc.main.cidr_block, 2)]

  authentication_options {
    type                           = "federated-authentication"
    saml_provider_arn              = aws_iam_saml_provider.aws-client-vpn.arn
    self_service_saml_provider_arn = aws_iam_saml_provider.aws-client-vpn-self-service.arn
  }

  connection_log_options {
    enabled = false
  }

  client_login_banner_options {
    enabled     = true
    banner_text = "This is a PRIVATE network. Unauthorized access is prohibited."
  }
}

resource "aws_ec2_client_vpn_network_association" "private-eu-central-1a" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  subnet_id              = data.aws_subnet.private-eu-central-1a.id
}

resource "aws_ec2_client_vpn_network_association" "private-eu-central-1b" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  subnet_id              = data.aws_subnet.private-eu-central-1b.id
}

resource "aws_ec2_client_vpn_authorization_rule" "internal_dns" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  target_network_cidr    = data.aws_vpc.main.cidr_block
  access_group_id        = aws_identitystore_group.admins.group_id
}
