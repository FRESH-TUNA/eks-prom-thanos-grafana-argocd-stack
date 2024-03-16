resource "aws_lb_listener_rule" "thanos" {
  listener_arn = aws_lb_listener.thanos.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_listener" "thanos" {
  load_balancer_arn = aws_lb.dmz.arn
  port              = "30263"
  protocol          = "HTTP"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks.arn
  }
}

resource "aws_lb" "dmz" {
  desync_mitigation_mode                      = "defensive"
  drop_invalid_header_fields                  = "false"

  enable_cross_zone_load_balancing            = "true"
  enable_deletion_protection                  = "false"
  enable_http2                                = "true"
  enable_tls_version_and_cipher_suite_headers = "false"
  enable_waf_fail_open                        = "false"
  enable_xff_client_port                      = "false"

  idle_timeout                                = "60"
  internal                                    = "false"
  ip_address_type                             = "ipv4"
  load_balancer_type                          = "application"

  name                                        = "alb-dmz"
  preserve_host_header                        = "false"
  security_groups                             = [aws_security_group.sg-dmz-agw.id]

#   subnet_mapping {
#     subnet_id = "subnet-0b9f0e192b14560fb"
#   }

#   subnet_mapping {
#     subnet_id = "subnet-0eecee20295fd3772"
#   }

  subnets = [aws_subnet.dmz-agw-a.id, aws_subnet.dmz-agw-b.id]

  tags = {
    group = "practice-prod"
  }

  tags_all = {
    group = "practice-prod"
  }

  xff_header_processing_mode = "append"
}

resource "aws_lb_target_group" "eks" {
  vpc_id      = aws_vpc.monitoring-practice.id
  deregistration_delay = "300"

  health_check {
    enabled             = "true"
    healthy_threshold   = "5"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "30263"
    protocol            = "HTTP"
    timeout             = "5"
    unhealthy_threshold = "2"
  }

  ip_address_type                   = "ipv4"
  load_balancing_algorithm_type     = "round_robin"
  load_balancing_cross_zone_enabled = "use_load_balancer_configuration"
  name                              = "dmz-targetgroup"
  port                              = "30263"
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

resource "aws_autoscaling_attachment" "eks" {
  autoscaling_group_name = module.eks.eks_managed_node_groups_autoscaling_group_names[0]
  lb_target_group_arn    = aws_lb_target_group.eks.arn
}
