
# modules for eks runner configuration 
locals {
  state_bucket     = "kojitechs.aws.eks.with.terraform.tf"
  state_bucket_key = format("env:/%s/path/env", terraform.workspace)
}

module "helm_configuration" {
  source = "./modules"

  state_bucket     = local.state_bucket
  state_bucket_key = local.state_bucket_key
  github_token     = var.github_token

  arc_namespace     = var.arc_namespace
  arc_chart_version = var.arc_chart_version
  arc_repo_url      = var.arc_repo_url

  cert_repoitory     = var.cert_repoitory
  cert_chart_version = var.cert_chart_version

  scaling_runners       = csvdecode(file("template/scaling_runners.csv"))
  organizations_runners = csvdecode(file("template/organizations_runners.csv"))
}
