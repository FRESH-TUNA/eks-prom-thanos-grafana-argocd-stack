resource "helm_release" "kube-prometheus-stack" {
  name       = "kube-prometheus-stack"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "prometheus-community/kube-prometheus-stack"
  version    = "56.21.4"

  values = [
    "${file("prometheus-stack-values.yaml")}"
  ]
}
