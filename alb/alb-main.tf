resource "aws_lb" "main" {
  name               = "${var.name}-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_security_groups
  subnets            = var.subnets.*.id

  enable_deletion_protection = false

  tags = {
    Name        = "${var.name}-alb-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_alb_target_group" "main" {
  name        = "${var.name}-tg-${var.environment}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.name}-tg-${var.environment}"
    Environment = var.environment
  }
}

# Redirect to https listener
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main.id
  port              = 80
  protocol          = "HTTP"

   default_action {
        target_group_arn = aws_alb_target_group.main.id
        type             = "forward"
    }
  
}



output "aws_alb_target_group_arn" {
  value = aws_alb_target_group.main.arn
}
