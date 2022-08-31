
data "terraform_remote_state" "kubernetes" {
  backend = "s3"

  config = {
    region = var.region
    bucket = var.state_bucket
    key    = var.state_bucket_key
  }
}

locals {
  kubernetes_cert        = data.terraform_remote_state.kubernetes.outputs
  k8sendpoint            = local.kubernetes_cert.cluster_endpoint
  certificate_authority  = local.kubernetes_cert.cluster_certificate_authority_data
  cluster_id             = local.kubernetes_cert.cluster_id
  cluster_ca_certificate = base64decode(local.certificate_authority)
  token                  = data.aws_eks_cluster_auth.cluster.token
  cert_name              = var.cert_namespace
}

data "aws_eks_cluster_auth" "cluster" {
  name = local.cluster_id
}

resource "helm_release" "cert_manager" {
  name             = local.cert_name
  repository       = var.cert_repoitory
  chart            = local.cert_name
  version          = var.cert_chart_version
  namespace        = local.cert_name
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  dynamic "set" {
    for_each = var.additional_set 
    content {
      name = set.value.name
      value = set.value.value
      type = lookup(set.value, "type", null)
    }
  }
  depends_on = [
    kubernetes_namespace.github_runner
  ]

}

resource "helm_release" "github_runner" {
  name        = var.arc_name
  repository  = var.arc_repo_url
  chart       = var.arc_chart_name
  version     = var.arc_chart_version
  namespace   = var.arc_namespace
  max_history = var.arc_max_history
  timeout     = var.arc_timeout

  set {
    name  = "syncPeriod"
    value = "1m"
  }

  set {
    name  = "authSecret.create"
    value = true
  }

  set {
    name  = "authSecret.github_token"
    value = var.github_token
  }

  depends_on = [
    kubernetes_namespace.github_runner
  ]
}

