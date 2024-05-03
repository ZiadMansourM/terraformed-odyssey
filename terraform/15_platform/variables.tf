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

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "eks-cluster-production"
}

variable "slack_token" {
  description = "The Slack token to use for notifications."
  type        = string
  default     = "xoxb-7013808384532-7004747320342-aWaHljQazh1lgpUovWPtrEs4"
}
