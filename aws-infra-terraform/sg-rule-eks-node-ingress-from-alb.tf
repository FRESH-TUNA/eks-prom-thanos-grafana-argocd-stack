resource "aws_security_group_rule" "eks-node-ingress-from-alb" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = module.eks.cluster_primary_security_group_id
  source_security_group_id = aws_security_group.sg-dmz-agw.id
}
