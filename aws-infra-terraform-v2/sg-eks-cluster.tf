resource "aws_security_group" "sg-eks-cluster" {
  name        = "eks-cluster"
  description = "eks-cluster"
  vpc_id      = aws_vpc.monitoring-practice.id

  tags = {
    Name = "eks-cluster"
  }
}

# api server inbound from eks jump server
resource "aws_vpc_security_group_ingress_rule" "eks-cluster-inbound-from-eks-jumper" {
  security_group_id = aws_security_group.sg-eks-cluster.id
  referenced_security_group_id = aws_security_group.sg-private-jumper.id

  ip_protocol = "tcp"
  from_port         = 443
  to_port           = 443
}

# api server inbound from kube proxy of node
resource "aws_vpc_security_group_ingress_rule" "eks-cluster-inbound-from-node" {
  security_group_id = aws_security_group.sg-eks-cluster.id
  referenced_security_group_id = aws_security_group.sg-eks-node.id

  ip_protocol = "tcp"
  from_port         = 443
  to_port           = 443
}

# inbound self
resource "aws_vpc_security_group_ingress_rule" "eks-cluster-inbound-self" {
  security_group_id = aws_security_group.sg-eks-cluster.id
  referenced_security_group_id = aws_security_group.sg-eks-cluster.id

  ip_protocol = "-1"
}

# global outbound
resource "aws_vpc_security_group_egress_rule" "sg-eks-cluster-outbound" {
  security_group_id = aws_security_group.sg-eks-cluster.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}
