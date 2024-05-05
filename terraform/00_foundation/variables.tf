variable "region" {
  description = "The AWS region to deploy the resources."
  type        = string
  default     = "eu-central-1"
}

variable "profile" {
  description = "The AWS profile to use."
  type        = string
  default     = "terraform"
}

variable "aws_vpc_main_cidr" {
  description = "The CIDR block of the main VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "eks-cluster-production"
}

variable "eks_master_version" {
  description = "The Kubernetes version of the EKS cluster."
  type        = string
  default     = "1.28"
}

variable "worker_nodes_k8s_version" {
  description = "The Kubernetes version of the EKS worker nodes."
  type        = string
  default     = "1.28"
}

variable "node_group_scaling_config" {
  description = "The scaling configuration for the EKS node group."

  type = object({
    desired_size = number
    max_size     = number
    min_size     = number
  })

  default = {
    desired_size = 4
    max_size     = 4
    min_size     = 4
  }
}
