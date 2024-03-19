resource "aws_iam_role" "thanos" {
  name = "thanos"

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
          # "Federated": "arn:aws:iam::account_number:oidc-provider/oidc.eks.us-east-2.amazonaws.com/id/OIDC_OF_EKS_CLUSTER",
          "Federated": "${module.eks.oidc_provider_arn}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringLike": {
            # "oidc.eks.us-east-2.amazonaws.com/id/OIDC_OF_EKS_CLUSTER:sub": "system:serviceaccount::",
            # "oidc.eks.us-east-2.amazonaws.com/id/OIDC_OF_EKS_CLUSTER:aud": "sts.amazonaws.com"
            "${module.eks.oidc_provider}:sub": "system:serviceaccount:monitoring:kube-prometheus-stack-prometheus",
            "${module.eks.oidc_provider}:aud": "sts.amazonaws.com"
          }
        }
      },
      {
        "Effect": "Allow",
        "Principal": {
          # "Federated": "arn:aws:iam::account_number:oidc-provider/oidc.eks.us-east-2.amazonaws.com/id/OIDC_OF_EKS_CLUSTER",
          "Federated": "${module.eks.oidc_provider_arn}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringLike": {
            # "oidc.eks.us-east-2.amazonaws.com/id/OIDC_OF_EKS_CLUSTER:sub": "system:serviceaccount::",
            # "oidc.eks.us-east-2.amazonaws.com/id/OIDC_OF_EKS_CLUSTER:aud": "sts.amazonaws.com"
            "${module.eks.oidc_provider}:sub": "system:serviceaccount:monitoring:thanos-storegateway",
            "${module.eks.oidc_provider}:aud": "sts.amazonaws.com"
          }
        }
      },
      {
        "Effect": "Allow",
        "Principal": {
          # "Federated": "arn:aws:iam::account_number:oidc-provider/oidc.eks.us-east-2.amazonaws.com/id/OIDC_OF_EKS_CLUSTER",
          "Federated": "${module.eks.oidc_provider_arn}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringLike": {
            # "oidc.eks.us-east-2.amazonaws.com/id/OIDC_OF_EKS_CLUSTER:sub": "system:serviceaccount::",
            # "oidc.eks.us-east-2.amazonaws.com/id/OIDC_OF_EKS_CLUSTER:aud": "sts.amazonaws.com"
            "${module.eks.oidc_provider}:sub": "system:serviceaccount:monitoring:thanos-compactor",
            "${module.eks.oidc_provider}:aud": "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "thanos" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = [
      aws_s3_bucket.thanos.arn,
      "${aws_s3_bucket.thanos.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "thanos" {
  name        = "thanos"
  description = "thanos"
  policy      = data.aws_iam_policy_document.thanos.json
}

resource "aws_iam_role_policy_attachment" "thanos" {
  role       = aws_iam_role.thanos.name
  policy_arn = aws_iam_policy.thanos.arn
}
