resource "helm_release" "kube-prometheus-stack" {
  name       = "kube-prometheus-stack"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "56.21.4"

  values = [
    "${file("prometheus-stack-values.yaml")}"
  ]
}
