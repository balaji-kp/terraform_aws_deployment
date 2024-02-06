# creating target group
resource "aws_lb_target_group" "web-tier-tg" {
  name     = "web-tier-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc-id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

# creating load balancer
#create alb
resource "aws_lb" "web-tier-alb" {
  name               = "web-tier-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.webSg.id]
  subnets         = [aws_subnet.sub1.id, aws_subnet.sub2.id]

  tags = {
    Name = "web"
  }
}

# attach alb with target group by mention alb listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.web-tier-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.web-tier-tg.arn
    type             = "forward"
  }
}

# attach ec2 with target group
resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.web-tier-tg.arn
  target_id        = aws_instance.webserver.id
  port             = 80
}
