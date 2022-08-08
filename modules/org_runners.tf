
resource "kubectl_manifest" "github_oragnization_runners" {
  for_each = { for repo in var.organizations_runners :
    repo.name => repo
  }
  yaml_body = <<YAML
---  
apiVersion: actions.summerwind.dev/v1alpha1
kind: RunnerDeployment
metadata:
  name: ${replace(lower(each.value.name), "/", "-")}
  namespace: ${var.arc_namespace}
spec:
  replicas: ${each.value.replicas}
  template:
    spec:
      organization: ${var.organization}
      labels:
        - ${each.value.label}
 
---
YAML

  depends_on = [helm_release.github_runner]
}

resource "kubectl_manifest" "horizontal_runner_autoscaler" {
  for_each = { for repo in var.scaling_organization_runners :
    repo.name => repo
  }
  yaml_body = <<YAML
---  
apiVersion: actions.summerwind.dev/v1alpha1
kind: HorizontalRunnerAutoscaler
metadata:
  name: ${replace(lower(each.value.name), "/", "-")}
  namespace: ${var.arc_namespace}
spec:
  scaleTargetRef:
    name: ${replace(lower(each.value.name), "/", "-")}
  scaleDownDelaySecondsAfterScaleOut: 300
  minReplicas: ${each.value.minreplicas} 
  maxReplicas: ${each.value.maxreplicas} 
  metrics:
    - type: PercentageRunnersBusy
      scaleUpThreshold: '0.75'
      scaleDownThreshold: '0.25'
      scaleUpFactor: '2'
      scaleDownFactor: '0.5'  
---
YAML

  depends_on = [helm_release.github_runner, kubectl_manifest.github_oragnization_runners]
}
