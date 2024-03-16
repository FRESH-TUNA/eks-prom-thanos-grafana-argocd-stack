module "helm" {
  source = "./helm/"

  providers = {
    helm = helm.eks
  }
}

module "kubernetes" {
  source = "./kubernetes/"

  providers = {
    kubernetes = kubernetes.eks
  }
}
