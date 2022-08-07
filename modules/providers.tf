

terraform {

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.5.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.13.0"
    }
  }
}

provider "kubernetes" {
  host                   = local.k8sendpoint
  cluster_ca_certificate = local.cluster_ca_certificate
  token                  = local.token
}

provider "kubectl" {

  host                   = local.k8sendpoint
  cluster_ca_certificate = local.cluster_ca_certificate
  token                  = local.token
}

provider "helm" {
  kubernetes {
    host                   = local.k8sendpoint
    cluster_ca_certificate = local.cluster_ca_certificate
    token                  = local.token
  }
}