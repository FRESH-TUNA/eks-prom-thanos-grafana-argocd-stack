resource "aws_iam_role" "eks-cni-irsa" {
  name = "eks-cni-irsa"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      },
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "${aws_iam_openid_connect_provider.eks-cluster.arn}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringLike": {
            "${replace(aws_iam_openid_connect_provider.eks-cluster.url, "https://", "")}:sub": "system:serviceaccount:kube-system:aws-node",
            "${replace(aws_iam_openid_connect_provider.eks-cluster.url, "https://", "")}:aud": "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks-cni-irsa" {
  role       = aws_iam_role.eks-cni-irsa.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  depends_on = [aws_iam_role.eks-cni-irsa]
}
