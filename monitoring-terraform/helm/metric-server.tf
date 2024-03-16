resource "helm_release" "metrics_server" {
  namespace        = "kube-system"
  name             = "metrics-server"
  chart            = "metrics-server"
  version          = "3.11.0"
  repository       = "https://kubernetes-sigs.github.io/metrics-server/"
  
  values = [
    "${file("${path.module}/metric-server-values.yaml")}"
  ]
}
