resource "aws_s3_bucket" "thanos" {
  bucket = "thanos"
  force_destroy = true
  tags = {
    Name        = "thanos"
  }
}
