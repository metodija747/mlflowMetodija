resource "aws_lb" "mlflow_alb" {
  name               = "mlflow-public-alb-eu-west-1"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]
  ip_address_type            = "ipv4"
  enable_deletion_protection = false
  idle_timeout               = 60

  tags = {
    Name = "mlflow-public-alb-eu-west-1"
  }
}

resource "aws_lb_target_group" "mlflow_tg" {
  name        = "mlflow-tg-eu-west-1"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "instance"

  health_check {
    protocol           = "HTTP"
    port               = "80"
    path               = "/"
    matcher            = "200-399"
    interval           = 30
    timeout            = 5
    healthy_threshold  = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "mlflow-tg-eu-west-1"
  }
}

resource "aws_lb_target_group_attachment" "mlflow_ec2_attach" {
  target_group_arn = aws_lb_target_group.mlflow_tg.arn
  target_id        = aws_instance.mlflow_server.id
  port             = 80
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.mlflow_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_302"
    }
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.mlflow_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  certificate_arn = aws_acm_certificate_validation.mlflow_cert_validation.certificate_arn

  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.mlflow_tg.arn
        weight = 1
      }
      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }
}
