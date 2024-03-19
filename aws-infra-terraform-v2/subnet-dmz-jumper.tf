# aws subnet
resource "aws_subnet" "dmz-jumper-a" {
  vpc_id                  = aws_vpc.monitoring-practice.id
  cidr_block              = "10.0.0.0/26"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true

  # k8s 내에서 ingress 생성 시 서브넷 자동 지정, 지금은 사용안함
  # tags = {
  #   "kubernetes.io/role/elb" = 1
  # }
}

resource "aws_subnet" "dmz-jumper-b" {
  vpc_id                  = aws_vpc.monitoring-practice.id
  cidr_block              = "10.0.0.64/26"
  availability_zone       = "ap-northeast-2b"
  map_public_ip_on_launch = true

  # k8s 내에서 ingress 생성 시 서브넷 자동 지정, 지금은 사용안함
  # tags = {
  #   "kubernetes.io/role/elb" = 1
  # }
}
