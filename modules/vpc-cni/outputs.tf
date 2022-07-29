output "pod_security_group_id" {
  description = "Security group ID attached to the EKS pods."
  value       = local.pod_security_group_id
}

output "vpc_cni_iam_role_name" {
  description = "IAM role name used by the Amazon CNI plugin addon."
  value       = local.vpccnirole_name
}

output "vpc_cni_iam_role_arn" {
  description = "IAM role ARN used by the Amazon CNI plugin addon."
  value       = local.service_account_role_arn
}

output "vpc_cni_addon_id" {
  description = "Amazon CNI plugin addon ID."
  value       = var.create ? aws_eks_addon.vpccni[0].id : ""
}

output "vpc_cni_addon_arn" {
  description = "Amazon CNI plugin addon ARN."
  value       = var.create ? aws_eks_addon.vpccni[0].id : ""
}
