resource "aws_route_table" "dmz" {
  vpc_id = aws_vpc.monitoring-practice.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "dmz"
  }
}

# agw
resource "aws_route_table_association" "dmz-agw-a" {
  subnet_id      = aws_subnet.dmz-agw-a.id
  route_table_id = aws_route_table.dmz.id
}

resource "aws_route_table_association" "dmz-agw-b" {
  subnet_id      = aws_subnet.dmz-agw-b.id
  route_table_id = aws_route_table.dmz.id
}

# nat
resource "aws_route_table_association" "dmz-nat-a" {
  subnet_id      = aws_subnet.dmz-nat-a.id
  route_table_id = aws_route_table.dmz.id
}

resource "aws_route_table_association" "dmz-nat-b" {
  subnet_id      = aws_subnet.dmz-nat-b.id
  route_table_id = aws_route_table.dmz.id
}

# jumpers
# nat
resource "aws_route_table_association" "dmz-jumper-a" {
  subnet_id      = aws_subnet.dmz-jumper-a.id
  route_table_id = aws_route_table.dmz.id
}

resource "aws_route_table_association" "dmz-jumper-b" {
  subnet_id      = aws_subnet.dmz-jumper-b.id
  route_table_id = aws_route_table.dmz.id
}

# resource "aws_route_table_association" "dmz-agw-dmz-c" {
#   subnet_id      = aws_subnet.agw-dmz-c.id
#   route_table_id = aws_route_table.public.id
# }

# resource "aws_route_table_association" "dmz-agw-dmz-d" {
#   subnet_id      = aws_subnet.agw-dmz-d.id
#   route_table_id = aws_route_table.public.id
# }
