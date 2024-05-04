output "iam_ic_instance_arns" {
  value = tolist(data.aws_ssoadmin_instances.iam_ic_instance.arns)
}

output "iam_ic_instance_identity_store_ids" {
  value = tolist(data.aws_ssoadmin_instances.iam_ic_instance.identity_store_ids)
}
