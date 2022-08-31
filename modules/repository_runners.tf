
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

resource "kubectl_manifest" "github_repositore" {
  for_each = { for repo in var.github_repositore : repo.name => repo }
  yaml_body  = <<YAML
---  
apiVersion: actions.summerwind.dev/v1alpha1
kind: RunnerSet
metadata:
  name: ${replace(lower(each.value.name), "/", "-") == null ? "Example" :  replace(lower(each.value.name), "/", "-")}
  namespace: ${var.arc_namespace}
spec:
  replicas: 1
  repository: Kojitechs-101/${each.value.repository_name}
  labels:
    - ${each.value.label} 
  dockerdWithinRunnerContainer: true
  template:
    spec:
      securityContext:
        seLinuxOptions:
          level: "s0"
          role: "system_r"
          type: "super_t"
          user: "system_u"
      containers:
      - name: runner
        env: []
        resources:
          limits:
            cpu: "4.0"
            memory: "8Gi"
          requests:
            cpu: "2.0"
            memory: "4Gi"
      
        securityContext:
         
      - name: docker
        resources:
          limits:
            cpu: "4.0"
            memory: "8Gi"
          requests:
            cpu: "2.0"
            memory: "4Gi"
---      
YAML
  depends_on = [helm_release.github_runner]

}