
variable "state_bucket" {
  type        = string
  description = "target state bucket to deploy action runners"
}

variable "region" {
  type        = string
  description = "AWS region to deploy action runners"
  default     = "us-east-1"
}

variable "state_bucket_key" {
  type        = string
  description = "target state bucket to deploy"
}

variable "cert_chart_version" {
  type        = string
  description = "HELM Chart Version for cert-manager"
}

variable "github_token" {
  description = "This varible contains token use to manage access to create an manage runners at orgs/repository level "
  type        = string
  sensitive   = true
}

variable "arc_timeout" {
  description = "Timeout to wait for the Chart to be deployed."
  type        = number
  default     = 300
}

variable "arc_max_history" {
  description = "Max History for Helm."
  type        = number
  default     = 20
}

variable "arc_chart_name" {
  type        = string
  default     = "actions-runner-controller"
  description = "Helm chart name to be installed"
}

variable "arc_chart_version" {
  type        = string
  description = "GitHub Runner Controller Helm chart version."
}

variable "arc_repo_url" {
  type        = string
  description = "GitHub Runner Controller Helm repository name."
}

variable "cert_repoitory" {
  type        = string
  description = "GitHub Runner Controller Helm repository name."
}

variable "arc_name" {
  description = "Helm release name."
  type        = string
  default     = "actions-runner-controller"
}

variable "scaling_organization_runners" {
  type = list(object({
    name        = string
    minreplicas = number
    maxreplicas = number
  }))
  default = []
}

variable "scaling_repository_runners" {
  type = list(object({
    name        = string
    minreplicas = number
    maxreplicas = number
  }))
  default = []
}

variable "organizations_runners" {
  type = list(object({
    name     = string
    replicas = number
    label    = string
    group    = string
  }))
  default = []
}

variable "repositories_runners" {
  type = list(object({
    name            = string
    repository_name = string
    replicas        = number
    label           = string
  }))
  default = []
}

variable "arc_namespace" {
  type        = string
  description = "action runner's  namespace name"
}

variable "cert_namespace" {
  type        = string
  default     = "cert-manager"
  description = "cert manager namespace"
}

variable "organization" {
  type    = string
  default = "Travelport-Enterprise"
}
