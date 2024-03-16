resource "helm_release" "thanos" {
  namespace  = "monitoring"
  name       = "thanos"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "thanos"
  version    = "13.4.1"

  values = [
    "${file("${path.module}/thanos-values.yaml")}"
  ]
}
