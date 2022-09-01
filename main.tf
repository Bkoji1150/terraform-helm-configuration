
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
  arc_repo_url      = var.arc_repo_url
  additional_set = [
    {
      name = "webhook.securePort"
      value = "10260"
    }
  ]

  cert_repoitory     = var.cert_repoitory

 #github_repositore       = csvdecode(file("template/github_repositore.csv"))
  scaling_runners       = csvdecode(file("template/scaling_runners.csv"))
  organizations_runners = csvdecode(file("template/organizations_runners.csv"))
 repositories_runners =  csvdecode(file("template/repositories_runners.csv"))
}
