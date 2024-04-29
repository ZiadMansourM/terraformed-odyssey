locals {
  tags = {
    author                   = "ziadh"
    "karpenter.sh/discovery" = var.cluster_name
  }
}
