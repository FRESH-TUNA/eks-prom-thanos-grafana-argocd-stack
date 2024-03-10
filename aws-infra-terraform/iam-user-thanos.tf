resource "aws_iam_user" "thanos" {
  name = "thanos"

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_access_key" "thanos" {
  user = aws_iam_user.thanos.name
}

data "aws_iam_policy_document" "thanos" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "lb_ro" {
  name   = "test"
  user   = aws_iam_user.lb.name
  policy = data.aws_iam_policy_document.lb_ro.json
}
