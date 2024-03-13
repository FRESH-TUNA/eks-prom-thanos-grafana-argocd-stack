resource "aws_lb_listener_rule" "thanos-frontend" {
  listener_arn = aws_lb_listener.thanos-frontend.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.thanos-frontend.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_listener" "thanos-frontend" {
  load_balancer_arn = aws_lb.dmz.arn
  port              = "31004"
  protocol          = "HTTP"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.thanos-frontend.arn
  }
}