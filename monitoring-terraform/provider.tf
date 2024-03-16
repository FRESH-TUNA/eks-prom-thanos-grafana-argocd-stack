provider "kubernetes" {
  alias = "eks"
  config_path = "~/.kube/config"
}

provider "helm" {
  alias = "eks"
  kubernetes {
    config_path = "~/.kube/config"
  }
}
