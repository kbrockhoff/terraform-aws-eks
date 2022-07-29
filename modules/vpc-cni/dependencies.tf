data "aws_region" "current" {}

data "aws_vpc" "selected" {
  count = var.create ? 1 : 0

  id = var.vpc_id
}

data "aws_subnet" "pod" {
  for_each = toset(var.create ? var.pod_subnets : [])

  id = each.value
}

data "aws_eks_cluster" "cluster" {
  count = var.create ? 1 : 0

  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  count = var.create ? 1 : 0

  name = var.cluster_name
}

data "external" "cni_cfg" {
  count = var.create ? 1 : 0

  program = ["${path.module}/scripts/check-cni-config.sh"]
  query = {
    kubeserver = data.aws_eks_cluster.cluster[0].endpoint
    kubetoken  = data.aws_eks_cluster_auth.cluster[0].token
    kubeca     = local_file.kube_ca[0].filename
  }
}
