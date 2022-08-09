resource "kubernetes_namespace" "github_runner" {

  metadata {
    name = var.arc_namespace
  }
}
