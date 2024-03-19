# dmz nat
resource "aws_subnet" "dmz-nat-a" {
  vpc_id                  = aws_vpc.monitoring-practice.id
  cidr_block              = "10.0.1.0/26"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "dmz-nat-b" {
  vpc_id                  = aws_vpc.monitoring-practice.id
  cidr_block              = "10.0.1.64/26"
  availability_zone       = "ap-northeast-2b"
  map_public_ip_on_launch = true
}
