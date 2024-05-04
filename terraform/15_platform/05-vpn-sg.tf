resource "aws_security_group" "this" {
  name        = "${var.cluster_name}-client-vpn"
  description = "Egress ALL, used for other SGs where vpn access is required."
  vpc_id      = data.aws_eks_cluster.cluster.vpc_config.0.vpc_id
}

resource "aws_security_group_rule" "this" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}
