resource "aws_route_table" "private-a" {
  vpc_id = aws_vpc.monitoring-practice.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-dmz-a.id
  }

  tags = {
    Name = "private"
  }
}

resource "aws_route_table" "private-b" {
  vpc_id = aws_vpc.monitoring-practice.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-dmz-b.id
  }

  tags = {
    Name = "private"
  }
}

# private-eks-node to internet
resource "aws_route_table_association" "private-eks-node-a" {
  subnet_id      = aws_subnet.private-eks-node-a.id
  route_table_id = aws_route_table.private-a.id
}

resource "aws_route_table_association" "private-eks-node-b" {
  subnet_id      = aws_subnet.private-eks-node-b.id
  route_table_id = aws_route_table.private-b.id
}

# private-jumper to internet
resource "aws_route_table_association" "private-jumper-a" {
  subnet_id      = aws_subnet.private-jumper-a.id
  route_table_id = aws_route_table.private-a.id
}

resource "aws_route_table_association" "private-jumper-b" {
  subnet_id      = aws_subnet.private-jumper-b.id
  route_table_id = aws_route_table.private-b.id
}
