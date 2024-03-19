resource "aws_s3_bucket" "thanos" {
  bucket = "thanos-monitoring-practice"
  force_destroy = true
  tags = {
    Name        = "thanos"
  }
}
