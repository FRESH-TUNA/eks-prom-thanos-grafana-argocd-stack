# eks node 
resource "aws_subnet" "private-eks-node-a" {
  vpc_id                  = aws_vpc.monitoring-practice.id
  cidr_block              = "10.0.112.0/20"
  availability_zone       = "ap-northeast-2a"

  # tags = {
  #   "kubernetes.io/cluster/demo" = "owned"
  # }
}

resource "aws_subnet" "private-eks-node-b" {
  vpc_id                  = aws_vpc.monitoring-practice.id
  cidr_block              = "10.0.128.0/20"
  availability_zone       = "ap-northeast-2b"

  # tags = {
  #   "kubernetes.io/cluster/demo" = "owned"
  # }
}
