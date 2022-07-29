variable "create" {
  description = "Determines whether to create EKS managed node group or not"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "cluster_name" {
  description = "Name of associated EKS cluster"
  type        = string
  default     = null
}

variable "cluster_version" {
  description = "Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.22`)"
  type        = string
  default     = null
}

variable "cluster_endpoint" {
  description = "Endpoint of associated EKS cluster"
  type        = string
  default     = ""
}

variable "cluster_auth_base64" {
  description = "Base64 encoded CA of associated EKS cluster"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC where the cluster and workers will be deployed."
  type        = string
}

variable "vpccni_version" {
  description = "vpc-cni addon version to use."
  type        = string
  default     = ""
}

variable "upgrade_resolve_conflicts" {
  description = "Define how to resolve parameter value conflicts when applying version updates to the add-on."
  type        = string
  default     = "NONE"

  validation {
    condition     = contains(["NONE", "OVERWRITE"], var.upgrade_resolve_conflicts)
    error_message = "Allowed values: NONE, OVERWRITE."
  }
}

variable "service_account_role_arn" {
  description = "The Amazon Resource Name (ARN) of an existing IAM role to bind to the add-on's service accoun or leave blank to create."
  type        = string
  default     = ""
}

variable "pod_subnets" {
  description = "A list of subnets to place the EKS pods within if using the vpc-cni addon."
  type        = list(string)
  default     = []
}

variable "enable_custom_network" {
  description = "Whether to enable the vpc-cni custom network env variable which should be true if pods use different subnet than nodes."
  type        = bool
  default     = true
}

variable "pod_create_security_group" {
  description = "When using vpc-cni whether to create a separate security group for the pods or attach the pod to `pod_security_group_id`."
  type        = bool
  default     = true
}

variable "pod_security_group_id" {
  description = "If provided, all pods will be attached to this security group. If not given, a security group will be created with necessary ingress/egress to work with the EKS cluster."
  type        = string
  default     = ""
}

variable "pods_egress_cidrs" {
  description = "List of CIDR blocks that are permitted for workers egress traffic."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_security_group_id" {
  description = "If provided, the EKS cluster will be attached to this security group. If not given, a security group will be created with necessary ingress/egress to work with the workers"
  type        = string
  default     = ""
}

variable "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster OIDC Issuer"
  type        = string
  default     = ""
}

variable "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider."
  type        = string
  default     = ""
}

variable "vpc_plugin_log_level" {
  description = "The logging level for the VPC CNI plugin."
  type        = string
  default     = "WARN"

  validation {
    condition     = contains(["DEBUG", "INFO", "WARN", "ERROR", "FATAL"], var.vpc_plugin_log_level)
    error_message = "Allowed values: DEBUG, INFO, WARN, ERROR, FATAL."
  }
}
