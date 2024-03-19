resource "aws_security_group" "sg-dmz-jumper" {
  name        = "dmz-jumper"
  description = "sg-dmz-jumper"
  vpc_id      = aws_vpc.monitoring-practice.id

  tags = {
    Name = "sg-dmz-jumper"
  }
}

resource "aws_vpc_security_group_ingress_rule" "sg-dmz-jumper" {
  security_group_id = aws_security_group.sg-dmz-jumper.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "sg-dmz-jumper-to-sg-private-jumper" {
  security_group_id = aws_security_group.sg-dmz-jumper.id
  referenced_security_group_id = aws_security_group.sg-private-jumper.id

  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}
