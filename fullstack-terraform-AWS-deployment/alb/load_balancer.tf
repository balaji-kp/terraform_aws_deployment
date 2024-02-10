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

  security_groups = [var.webSG]
  subnets         = [var.web-tier-sub1, var.web-tier-sub2]

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
  target_id        = var.web-instance-1
  port             = 80
}
resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.web-tier-tg.arn
  target_id        = var.web-instance-2
  port             = 80
}




# creating target group
resource "aws_lb_target_group" "app-tier-tg" {
  name     = "app-tier-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc-id

  health_check {
    path = "/users"
    port = "traffic-port"
  }
}

# creating load balancer
#create alb
resource "aws_lb" "app-tier-alb" {
  name               = "app-tier-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [var.webSG]
  subnets         = [var.app-tier-sub1, var.app-tier-sub2]

  tags = {
    Name = "app"
  }
}

# attach alb with target group by mention alb listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.app-tier-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.app-tier-tg.arn
    type             = "forward"
  }
}

# attach ec2 with target group
resource "aws_lb_target_group_attachment" "attach3" {
  target_group_arn = aws_lb_target_group.app-tier-tg.arn
  target_id        = var.app-instance-1
  port             = 80
}
resource "aws_lb_target_group_attachment" "attach4" {
  target_group_arn = aws_lb_target_group.app-tier-tg.arn
  target_id        = var.app-instance-2
  port             = 80
}
