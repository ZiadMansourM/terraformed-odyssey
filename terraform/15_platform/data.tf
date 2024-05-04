data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

data "aws_ssoadmin_instances" "iam_ic_instance" {}

data "aws_ssoadmin_application" "aws-client-vpn" {
  application_arn = "arn:aws:sso::389461953806:application/ssoins-6987bed3364bf28e/apl-46b07f9989def354"
}

data "aws_ssoadmin_application" "aws-client-vpn-self-service" {
  application_arn = "arn:aws:sso::389461953806:application/ssoins-6987bed3364bf28e/apl-851ae78d7df4f23e"
}

data "aws_vpc" "main" {
  id = data.aws_eks_cluster.cluster.vpc_config.0.vpc_id
}

data "aws_subnet" "private-eu-central-1a" {
  filter {
    name   = "tag:Name"
    values = ["private-eu-central-1a"]
  }
}

data "aws_subnet" "private-eu-central-1b" {
  filter {
    name   = "tag:Name"
    values = ["private-eu-central-1b"]
  }
}
