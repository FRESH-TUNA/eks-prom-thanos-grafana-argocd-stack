# private jumper
resource "aws_subnet" "private-jumper-a" {
  vpc_id                  = aws_vpc.monitoring-practice.id
  cidr_block              = "10.0.97.0/26"
  availability_zone       = "ap-northeast-2a"
}

resource "aws_subnet" "private-jumper-b" {
  vpc_id                  = aws_vpc.monitoring-practice.id
  cidr_block              = "10.0.97.64/26"
  availability_zone       = "ap-northeast-2b"
}
