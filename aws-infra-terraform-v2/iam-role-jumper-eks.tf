resource "aws_iam_role" "jumper-eks" {
  name = "jumper-eks"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "jumper-eks" {
  statement {
    effect    = "Allow"
    actions   = ["eks:DescribeCluster"]
    resources = [aws_eks_cluster.eks-cluster.arn]
  }
}

resource "aws_iam_policy" "jumper-eks" {
  name        = "jumper-eks"
  description = "jumper-eks"
  policy      = data.aws_iam_policy_document.jumper-eks.json
}

resource "aws_iam_role_policy_attachment" "jumper-eks" {
  role       = aws_iam_role.jumper-eks.name
  policy_arn = aws_iam_policy.jumper-eks.arn
}
