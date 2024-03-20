resource "aws_lb_target_group" "thanos-frontend" {
  vpc_id      = aws_vpc.monitoring-practice.id
  deregistration_delay = "300"

  health_check {
    enabled             = "true"
    healthy_threshold   = "5"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "31004"
    protocol            = "HTTP"
    timeout             = "5"
    unhealthy_threshold = "2"
  }

  ip_address_type                   = "ipv4"
  load_balancing_algorithm_type     = "round_robin"
  load_balancing_cross_zone_enabled = "use_load_balancer_configuration"
  name                              = "thanos-frontend"
  port                              = "31004"
  protocol                          = "HTTP"
  protocol_version                  = "HTTP1"
  slow_start                        = "0"

  stickiness {
    cookie_duration = "86400"
    enabled         = "false"
    type            = "lb_cookie"
  }

  tags = {
    group = "practice-prod"
  }

  tags_all = {
    group = "practice-prod"
  }

  target_type = "instance"
}

resource "aws_autoscaling_attachment" "thanos-frontend" {
  autoscaling_group_name = aws_eks_node_group.eks_node_group.resources[0].autoscaling_groups[0].name
  lb_target_group_arn    = aws_lb_target_group.thanos-frontend.arn
}