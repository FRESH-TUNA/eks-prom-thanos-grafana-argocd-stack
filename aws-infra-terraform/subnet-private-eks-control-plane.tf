# eks control plane 
resource "aws_subnet" "private-eks-control-plane-a" {
  vpc_id                  = aws_vpc.monitoring-practice.id
  cidr_block              = "10.0.96.0/26"
  availability_zone       = "ap-northeast-2a"
}

resource "aws_subnet" "private-eks-control-plane-b" {
  vpc_id                  = aws_vpc.monitoring-practice.id
  cidr_block              = "10.0.96.64/26"
  availability_zone       = "ap-northeast-2b"
}
