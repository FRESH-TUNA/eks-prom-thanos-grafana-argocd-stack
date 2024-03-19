resource "aws_security_group" "sg-eks-node" {
  name        = "sg-eks-node"
  description = "sg-eks-node"
  vpc_id      = aws_vpc.monitoring-practice.id

  tags = {
    Name = "sg-eks-node"
  }
}

resource "aws_vpc_security_group_egress_rule" "eks-node-inbound-self" {
  security_group_id = aws_security_group.sg-eks-node.id
  referenced_security_group_id = aws_security_group.sg-eks-node.id

  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 65535
}

# EKS
resource "aws_vpc_security_group_ingress_rule" "eks-node-inbound-from-cluster" {
  security_group_id = aws_security_group.sg-eks-node.id
  referenced_security_group_id = aws_security_group.sg-eks-cluster.id

  ip_protocol = "tcp"
  from_port         = 10250
  to_port           = 10250
}

resource "aws_vpc_security_group_egress_rule" "eks-node-outbound-self" {
  security_group_id = aws_security_group.sg-eks-node.id
  referenced_security_group_id = aws_security_group.sg-eks-cluster.id
  
  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 65535
}

# ALB
resource "aws_vpc_security_group_ingress_rule" "eks-node-inbound-from-alb" {
  security_group_id = aws_security_group.sg-eks-node.id
  referenced_security_group_id = aws_security_group.sg-dmz-agw.id

  ip_protocol = "tcp"
  from_port         = 0
  to_port           = 65535
}

# global allow
resource "aws_vpc_security_group_egress_rule" "eks-node-outbound-all-allow" {
  security_group_id = aws_security_group.sg-eks-node.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 65535
}
