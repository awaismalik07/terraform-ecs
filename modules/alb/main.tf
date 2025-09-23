resource "aws_lb" "ApplicationLoadBalancer" {
  name               = "${var.owner}-${var.env}-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.ALBSGId]
  subnets            = var.PublicSubnetIds


  tags = {
    Name               = "${var.owner}-${var.env}-ALB"
  }
}

resource "aws_lb_listener" "ALBListener" {
  load_balancer_arn = aws_lb.ApplicationLoadBalancer.arn
  
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.AlbTargetGroup.arn
  }
}

resource "aws_lb_target_group" "AlbTargetGroup" {
  name        = "${var.owner}-${var.env}-alb-tg"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.VpcId

  health_check {
    protocol            = "HTTP"
    path                = var.HealthCheckPath
    matcher             = var.HealthyCodes
    interval            = var.HealthCheckInterval
    timeout             = var.Timeout
    healthy_threshold   = var.HealthyThreshold
    unhealthy_threshold = var.UnhealthThreshold
  }

}