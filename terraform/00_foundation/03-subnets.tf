# Resource: aws_subnet
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# Divide the VPC into 4 subnets:
# https://www.davidc.net/sites/default/subnets/subnets.html

resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.main.id

  cidr_block        = "10.0.0.0/18"
  availability_zone = "${var.region}a"

  # Required for EKS: Instances launched into the subnet
  # should be assigned a public IP address.
  map_public_ip_on_launch = true

  tags = merge(
    local.tags,
    {
      Name                                        = "public-${var.region}a"
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
      "kubernetes.io/role/elb"                    = "1"
    }
  )
}

resource "aws_subnet" "public_2" {
  vpc_id = aws_vpc.main.id

  cidr_block        = "10.0.64.0/18"
  availability_zone = "${var.region}b"

  # Required for EKS: Instances launched into the subnet
  # should be assigned a public IP address.
  map_public_ip_on_launch = true

  tags = merge(
    local.tags,
    {
      Name                                        = "public-${var.region}b"
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
      "kubernetes.io/role/elb"                    = "1"
    }
  )
}

resource "aws_subnet" "private_1" {
  vpc_id = aws_vpc.main.id

  cidr_block        = "10.0.128.0/18"
  availability_zone = "${var.region}a"

  tags = merge(
    local.tags,
    {
      Name                                        = "private-${var.region}a"
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
      "kubernetes.io/role/internal-elb"           = "1"
    }
  )
}

resource "aws_subnet" "private_2" {
  vpc_id = aws_vpc.main.id

  cidr_block        = "10.0.192.0/18"
  availability_zone = "${var.region}b"

  tags = merge(
    local.tags,
    {
      Name                                        = "private-${var.region}b"
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
      "kubernetes.io/role/internal-elb"           = "1"
    }
  )
}
