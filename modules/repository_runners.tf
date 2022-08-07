
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
  replicas: ${each.value.replicas}
  template:
    spec:
      repository: Travelport-Enterprise/${each.value.repository_name}
      labels:
        - ${each.value.label} 
---        
YAML
  depends_on = [helm_release.github_runner]

}

resource "kubectl_manifest" "githubrunners_horizontal_scaler" {
  for_each = { for repo in var.scaling_repository_runners :
    repo.name => repo
  }
  yaml_body = <<YAML
---  
apiVersion: actions.summerwind.dev/v1alpha1
kind: HorizontalRunnerAutoscaler
metadata:
  name: ${each.value.name}
  namespace: ${var.arc_namespace}
spec:
  scaleTargetRef:
    name: ${each.value.name}
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