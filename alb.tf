resource "aws_alb" "hoangla-alb" {
    name                = "hoangla-alb"
    internal            = false
    load_balancer_type  = "application"
    security_groups     = [aws_security_group.hoangla_sg_alb.id]
    subnets             = [aws_subnet.hoangla_public_subnet_1.id, aws_subnet.hoangla_public_subnet_2.id, aws_subnet.hoangla_public_subnet_3.id]

    tags = {
      Name = "hoangla-alb"
    }
}
resource "aws_lb_target_group" "hoangla_tg" {
  vpc_id      = aws_vpc.hoangla_vpc.id
  name        = "hoangla-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  health_check {
    path     = "/"
    protocol = "HTTP"
  }
}
resource "aws_lb_listener" "hoangla_listner" {
  load_balancer_arn = aws_alb.hoangla-alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.hoangla_tg.arn
    type             = "forward"
  }

  tags = {
    Name = "hoangla_listner"
  }
}