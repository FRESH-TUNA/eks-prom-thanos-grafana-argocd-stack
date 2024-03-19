resource "aws_security_group" "sg-eks-cluster" {
  name        = "sg-eks-cluster"
  description = "sg-eks-cluster"
  vpc_id      = aws_vpc.monitoring-practice.id

  tags = {
    Name = "sg-eks-cluster"
  }
}

resource "aws_vpc_security_group_ingress_rule" "eks-cluster-inbound-from-node" {
  security_group_id = aws_security_group.sg-eks-cluster.id
  referenced_security_group_id = aws_security_group.sg-eks-node.id

  ip_protocol = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "sg-eks-cluster-outbound" {
  security_group_id = aws_security_group.sg-eks-cluster.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 65535
}
