resource "kubernetes_secret" "secret-monitoring-thanos-s3" {
  metadata {
    name = "secret-monitoring-thanos-s3"
    namespace = kubernetes_namespace.monitoring.id
  }

  data = {
    "config" = "${file("${path.module}/secret-monitoring-thanos-s3.yaml")}"
  }

#   type = "kubernetes.io/dockerconfigjson"
}
