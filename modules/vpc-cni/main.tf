resource "aws_eks_addon" "vpccni" {
  count = var.create ? 1 : 0

  cluster_name             = var.cluster_name
  addon_name               = "vpc-cni"
  addon_version            = local.vpccni_version
  service_account_role_arn = local.service_account_role_arn
  resolve_conflicts        = var.upgrade_resolve_conflicts
}

resource "kubectl_manifest" "eniconfig" {
  for_each = { for sn in data.aws_subnet.pod : sn.id => sn }

  yaml_body = <<YAML
apiVersion: crd.k8s.amazonaws.com/v1alpha1
kind: ENIConfig
metadata:
 name: ${each.value.availability_zone}
spec:
 subnet: ${each.key}
 securityGroups:
 - ${var.pod_security_group_id}
YAML
}

resource "local_file" "config" {
  count = var.create && var.enable_custom_network ? 1 : 0

  content  = ""
  filename = "${path.module}/.terraform/config.yaml"
}

resource "local_file" "kube_ca" {
  count = var.create && var.enable_custom_network ? 1 : 0

  content  = base64decode(data.aws_eks_cluster.cluster[0].certificate_authority[0].data)
  filename = "${path.module}/.terraform/ca.crt"
}

resource "null_resource" "patch_cni" {
  count = var.create && var.enable_custom_network ? 1 : 0

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/config-custom-network.sh"

    environment = {
      KUBECONFIG  = local_file.config[0].filename
      KUBESERVER  = data.aws_eks_cluster.cluster[0].endpoint
      KUBETOKEN   = data.aws_eks_cluster_auth.cluster[0].token
      KUBECA      = local_file.kube_ca[0].filename
      CLUSTERNAME = var.cluster_name
      REGION      = data.aws_region.current.name
      CNI_STATUS  = local.customnetwork_status
      LOGLEVEL    = var.vpc_plugin_log_level
    }
  }

  depends_on = [kubectl_manifest.eniconfig]
}
