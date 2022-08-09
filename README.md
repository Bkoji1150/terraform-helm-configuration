# Create Github self runners in aws eks manafe cluster using terraform.

### To create a runner in this project go to the `template` Folder

## create oraganization runners

### `organizations_runners.csv`
```csv
name,                       replicas,       label
aws-eks-orgs-runners-test,    1,           aws-eks-test
```
### horizontally scale up oraganization runners

### `scalling_organizations_runners.csv`
```csv
name,                        minreplicas,              maxreplicas
aws-eks-orgs-runners-test,     2,                        10
```
## This module do create runners at repository level

## create repository runners

### `respository_runners.csv`
```csv
name                 ,repository_name                 ,replicas  ,label
deploy-terraform,       kojitechs-teraform-101,         1,       aws-enhance
```
### horizontally scale up respository runners

### `scalling_respository_runners.csv`
```csv
name             ,minreplicas ,maxreplicas
deploy-terraform ,          3 ,         10
```

<!-- prettier-ignore-start -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_helm_configuration"></a> [helm\_configuration](#module\_helm\_configuration) | ./modules | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_arc_chart_version"></a> [arc\_chart\_version](#input\_arc\_chart\_version) | GitHub Runner Controller Helm chart version. | `string` | `"0.20.2"` | no |
| <a name="input_arc_namespace"></a> [arc\_namespace](#input\_arc\_namespace) | action runner's  namespace name | `string` | `"actions-runner-system"` | no |
| <a name="input_arc_repo_url"></a> [arc\_repo\_url](#input\_arc\_repo\_url) | GitHub Runner Controller Helm repository name. | `string` | `"https://actions-runner-controller.github.io/actions-runner-controller"` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | Environment this template would be deployed to | `map(string)` | `{}` | no |
| <a name="input_cert_chart_version"></a> [cert\_chart\_version](#input\_cert\_chart\_version) | HELM Chart Version for cert-manager | `string` | `"1.9.1"` | no |
| <a name="input_cert_repoitory"></a> [cert\_repoitory](#input\_cert\_repoitory) | GitHub Runner Controller Helm repository name. | `string` | `"https://charts.jetstack.io"` | no |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | This varible contains token use to manage access to create an manage runners at orgs/repository level | `string` | n/a | yes |
| <a name="input_state_bucket"></a> [state\_bucket](#input\_state\_bucket) | target state bucket to deploy action runners | `string` | `"kojitechs.aws.eks.with.terraform.tf"` | no |
| <a name="input_state_bucket_key"></a> [state\_bucket\_key](#input\_state\_bucket\_key) | target state bucket to deploy | `string` | `"env:/sbx/path/env"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Steps to set & assume aws role
```bash
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_SESSION_TOKEN=
aws sts get-caller-identity
aws sts assume-role --role-arn arn:aws:iam::181437319056:role/Role_For-S3_Creation --role-session-name kubectl-Session
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_SESSION_TOKEN=
aws eks --region us-east-1 update-kubeconfig --name "cluster_name"
aws sts get-caller-identity
```
## kubectl commands
```bash
kubectl get pods --all-namespaces
kubectl get pods -n actions-runner-system
kubectl get pods,svc,namespaces,deployments,no,rs,ds --all-namespaces
```

## NOTE:
The `minreplicas` takes presidence over `replicas` when horizontal autoscaling is define for the action runners
