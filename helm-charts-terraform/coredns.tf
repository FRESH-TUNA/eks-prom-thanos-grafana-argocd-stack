resource "helm_release" "metrics_server" {
  namespace        = "kube-system"
  name             = "coredns"
  chart            = "coredns"
  version          = "1.29.0"
  repository       = "https://coredns.github.io/helm"
  
  values = [
    "${file("coredns-values.yaml")}"
  ]
}
