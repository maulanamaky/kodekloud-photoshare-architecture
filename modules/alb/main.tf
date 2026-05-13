resource "aws_lb" "photoshare_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.photoshare_alb_securitygroup.id]
  subnets            = var.public_subnet_ids
  ip_address_type    = var.ip_address_type

  enable_deletion_protection = var.enable_deletion_protection

  tags = {
    Name = var.alb_name
  }
}

resource "aws_lb_target_group" "photoshare_alb_targetgroup" {
  name     = var.targetgroup_name
  port     = var.targetgroup_port
  protocol = var.targetgroup_protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "photoshare_ec2_attachment" {
  target_group_arn = aws_lb_target_group.photoshare_alb_targetgroup.arn
  target_id        = var.ec2_instance_id
  port             = 80
}

resource "aws_lb_listener" "photoshare_alb_listener" {
  load_balancer_arn = aws_lb.photoshare_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.photoshare_alb_targetgroup.arn
  }
}
