locals {
  addon_versions_map = {
    "1.18" = "1.11.2-eksbuild.1"
    "1.19" = "1.11.2-eksbuild.1"
    "1.20" = "1.11.2-eksbuild.1"
    "1.21" = "1.11.2-eksbuild.1"
    "1.22" = "1.11.2-eksbuild.1"
  }
  vpccni_version = var.vpccni_version == null || length(var.vpccni_version) == 0 ? (
    lookup(local.addon_versions_map[var.cluster_version], "1.11.2-eksbuild.1")
  ) : var.vpccni_version

  create_iam_role = var.create && length(var.service_account_role_arn) == 0
  vpccnirole_name = "${var.cluster_name}-aws-node-irsa"
  service_account_role_arn = local.create_iam_role ? (
    aws_iam_role.aws_node_irsa[0].arn
  ) : var.service_account_role_arn
  secgroup_name        = "${var.cluster_name}-pods"
  customnetwork_status = data.external.cni_cfg[0].result["customnetwork"]
  pod_security_group_id = var.create && var.pod_create_security_group ? (
    aws_security_group.pods[0].id
    ) : (
    var.pod_security_group_id
  )
  vpc_cidrs = concat(
    [for cba in data.aws_vpc.selected.cidr_block_associations : cba.cidr_block],
    [for knc in data.aws_eks_cluster.cluster.kubernetes_network_config : knc.service_ipv4_cidr],
  )
}
