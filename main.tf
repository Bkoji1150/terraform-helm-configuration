
# modules for eks runner configuration 

module "helm_configuration" {
  source = "./modules"

  state_bucket     = var.state_bucket
  state_bucket_key = var.state_bucket_key
  github_token     = var.github_token

  arc_namespace     = var.arc_namespace
  arc_chart_version = var.arc_chart_version
  arc_repo_url      = var.arc_repo_url

  cert_repoitory     = var.cert_repoitory
  cert_chart_version = var.cert_chart_version

  # scaling_repository_runners   = csvdecode(file("template/scaling_repository_runners.csv"))
  scaling_organization_runners = csvdecode(file("template/scaling_organization_runners.csv"))
  organizations_runners        = csvdecode(file("template/organizations_runners.csv"))
  # repositories_runners         = csvdecode(file("template/repositories_runners.csv"))
}
