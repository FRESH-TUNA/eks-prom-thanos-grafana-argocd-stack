resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.monitoring-practice.id

  tags = {
    Name = "monitoring-practice"
  }
}
