resource "aws_eip" "nat-dmz-a" {
  tags = {
    Name = "nat-dmz-a"
  }
}

resource "aws_eip" "nat-dmz-b" {
  tags = {
    Name = "nat-dmz-b"
  }
}

resource "aws_nat_gateway" "nat-dmz-a" {
  allocation_id = aws_eip.nat-dmz-a.id
  subnet_id     = aws_subnet.dmz-nat-a.id

  tags = {
    Name = "nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat-dmz-b" {
  allocation_id = aws_eip.nat-dmz-b.id
  subnet_id     = aws_subnet.dmz-nat-b.id

  tags = {
    Name = "nat"
  }

  depends_on = [aws_internet_gateway.igw]
}
