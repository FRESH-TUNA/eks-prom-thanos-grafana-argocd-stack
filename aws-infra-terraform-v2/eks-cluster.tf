# Create AWS EKS Cluster
resource "aws_eks_cluster" "eks-cluster" {
  name     = "monitoring-cluster"
  role_arn = aws_iam_role.eks_master_role.arn
  version = "1.28"

  vpc_config {
    subnet_ids = [
      aws_subnet.private-eks-control-plane-a.id,
      aws_subnet.private-eks-control-plane-b.id
    ]
    endpoint_private_access = true
    endpoint_public_access  = false
    
    #public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
    security_group_ids = [aws_security_group.sg-eks-cluster.id]
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = false
  }

  kubernetes_network_config {
    service_ipv4_cidr = "10.1.0.0/16"
  }
  
  # Enable EKS Cluster Control Plane Logging
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
  ]
}

resource "aws_eks_access_entry" "jumper-eks" {
  cluster_name      = aws_eks_cluster.eks-cluster.name
  principal_arn     = aws_iam_role.jumper-eks.arn
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "jumper-eks" {
  cluster_name      = aws_eks_cluster.eks-cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = aws_iam_role.jumper-eks.arn

  access_scope {
    type       = "cluster"
    # namespaces = ["example-namespace"]
  }
}