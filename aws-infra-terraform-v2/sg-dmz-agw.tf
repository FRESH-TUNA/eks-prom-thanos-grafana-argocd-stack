resource "aws_security_group" "sg-dmz-agw" {
  name        = "dmz-agw"
  description = "dmz-agw"
  vpc_id      = aws_vpc.monitoring-practice.id

  tags = {
    Name = "dmz-agw"
  }
}

resource "aws_vpc_security_group_ingress_rule" "sg-dmz-agw" {
  security_group_id = aws_security_group.sg-dmz-agw.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 65535
}

resource "aws_vpc_security_group_egress_rule" "sg-dmz-agw" {
  security_group_id = aws_security_group.sg-dmz-agw.id
  referenced_security_group_id = aws_security_group.sg-eks-node.id

  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 65535
}
