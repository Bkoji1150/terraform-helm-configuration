
resource "kubectl_manifest" "github_repository_runners" {
  for_each = { for repo in var.repositories_runners :
    repo.repository_name => repo
  }
  yaml_body  = <<YAML
---  
apiVersion: actions.summerwind.dev/v1alpha1
kind: RunnerDeployment
metadata:
  name: ${replace(lower(each.value.name), "/", "-")}
  namespace: ${var.arc_namespace}
spec:
  template:
    spec:
      repository: Kojitechs-101/${each.value.repository_name}
      labels:
        - ${each.value.label} 
---      
YAML
  depends_on = [helm_release.github_runner]

}
