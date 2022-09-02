# Why deploy k8s with Terraform?
While you could use kubectl or similar CLI-based tools to manage your Kubernetes resources, using Terraform has the following benefits for our runners deploymemt:
## `Unified Workflow`
- If you are already provisioning Kubernetes clusters with Terraform, use the same configuration language to deploy your applications into your cluster.

## `Full Lifecycle Management` 
- Terraform doesn't only create resources, it updates, and deletes tracked resources without requiring you to inspect the API to identify those resources.

## Description
This project is meant to automate the creation of git action runners using helm provider and kubectl provider within terraform.
- runners could be created at the repository level as well as the organization level

## To create a runner in this project go to the `terraform.tfvars`

## oraganization runners
### NOTE: the `minreplicas` takes presidence over `replicas` when horizontal autoscaling is define for the action runners
```hcl
github_organizations = [
  {
    name     = "runner-name"
    replicas = 1
    label    = "lable-name"
    group    = "group-name"
  }
]

horizontal_runner = [
  {
    name        = "runner-name"
    minreplicas = 3
    maxreplicas = 9
  }
]
```

## repository runners

```hcl
github_repositories = [
  {
    name     = "Travelport-Enterprise/iaas-example-a"
    replicas = 2
    label    = "aws-eks"
    minreplicas = 3
    maxreplicas = 10
  }
]

```

```csv
 name,replicas,label,group
 runner-name,1,lable-name,group-name
```
## Steps to set & assume aws role
```bash
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_SESSION_TOKEN=
aws sts get-caller-identity
aws sts assume-role --role-arn arn:aws:iam::735972722491:role/Role_For-S3_Creation --role-session-name kubectl-Session
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_SESSION_TOKEN=
aws eks --region us-east-1 update-kubeconfig --name Kojitechs_aws_eks_cluster
aws sts get-caller-identity
```
## kubectl commands
```bash
kubectl get pods --all-namespaces
kubectl get pods -n actions-runner-system
kubectl get pods,svc,namespaces,deployments,no,rs,ds --all-namespaces
kubectl logs -f aws-eks-orgs-runners-test-xvts5-ttcx8 -n actions-runner-system runner
kubectl logs -f <pod_id> -n actions-runner-system docker
## ghp_bello_nDMNlbR9ldarSKCJMOcORD85LfO7Ld3MCmfwkoji
```
