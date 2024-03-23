resource "aws_security_group" "sg-eks-node" {
  name        = "eks-node"
  description = "eks-node"
  vpc_id      = aws_vpc.monitoring-practice.id

  tags = {
    Name = "eks-node"
  }
}

# inbound self ALL
resource "aws_vpc_security_group_ingress_rule" "eks-node-inbound-self" {
  security_group_id = aws_security_group.sg-eks-node.id
  referenced_security_group_id = aws_security_group.sg-eks-node.id

  ip_protocol = "-1" 
}

# EKS Node kubelet inbound from Cluster
resource "aws_vpc_security_group_ingress_rule" "eks-node-inbound-from-cluster" {
  security_group_id = aws_security_group.sg-eks-node.id
  referenced_security_group_id = aws_security_group.sg-eks-cluster.id

  ip_protocol = "tcp"
  from_port         = 10250
  to_port           = 10250
}

# EKS Node inbound from ALB
resource "aws_vpc_security_group_ingress_rule" "eks-node-inbound-from-alb" {
  security_group_id = aws_security_group.sg-eks-node.id
  referenced_security_group_id = aws_security_group.sg-dmz-agw.id

  ip_protocol = "tcp"
  from_port         = 0
  to_port           = 65535
}

# global outbound allow
resource "aws_vpc_security_group_egress_rule" "eks-node-outbound-all-allow" {
  security_group_id = aws_security_group.sg-eks-node.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}
