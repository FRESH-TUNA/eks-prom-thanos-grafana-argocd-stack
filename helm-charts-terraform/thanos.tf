resource "helm_release" "thanos" {
  name       = "thanos"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "thanos"
  version    = "13.4.1"

  values = [
    "${file("thanos-values.yaml")}"
  ]
}
