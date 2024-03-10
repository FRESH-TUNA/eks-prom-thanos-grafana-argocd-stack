resource "kubernetes_secret" "secret-monitoring-thanos-s3" {
  metadata {
    name = "secret-monitoring-thanos-s3"
  }

  data = {
    "config" = "${file("${path.module}/.credentials/secret-monitoring-thanos-s3.json")}"
  }

#   type = "kubernetes.io/dockerconfigjson"
}
