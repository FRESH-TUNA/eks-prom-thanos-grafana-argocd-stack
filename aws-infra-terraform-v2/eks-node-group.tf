resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "v2"
  node_role_arn   = aws_iam_role.eks-node-group.arn

  capacity_type = "ON_DEMAND"
  
  launch_template {
    name = aws_launch_template.eks_launch_template.name
    version = aws_launch_template.eks_launch_template.latest_version
  }

  subnet_ids = [
    aws_subnet.private-eks-node-a.id,
    aws_subnet.private-eks-node-b.id
  ]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-node-group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-node-group-AmazonEKS_CNI_Policy,
    # aws_iam_role_policy_attachment.eks-node-group-AmazonEC2ContainerRegistryReadOnly,
    # aws_iam_role_policy_attachment.eks-node-group-ElasticLoadBalancingFullAccess,
    aws_iam_role_policy_attachment.demo-node-Elastic,
  ]
}
