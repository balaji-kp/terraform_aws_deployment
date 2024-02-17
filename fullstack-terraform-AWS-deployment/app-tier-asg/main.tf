resource "aws_launch_configuration" "app-tier-launch-config" {
  image_id        = "ami-0449c34f967dbf18a"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.app-asg-sg.id}"]
  iam_instance_profile = "${var.aws_iam_instance_profile}"
  key_name = "WEBSERVER"
  user_data = <<-EOF
  #!/bin/bash
  echo export FRONTEND_ENDPOINT= ${var.web-tier-alb-endpoint} >> /etc/environment
  echo export DB_URL= ${var.rds-endpoint} >> /etc/environment
  export FRONTEND_ENDPOINT= ${var.web-tier-alb-endpoint}
  export DB_URL=${var.rds-endpoint}
  source /etc/environment
  dnf update -y
  dnf install java-17-amazon-corretto -y
  aws s3 cp s3://my-springboot-artifact/springboot-Mysql-loginpageDemo.jar .
  nohup java -jar springboot-Mysql-loginpageDemo.jar >>/tmp/ouput.log &
  EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app-tier-ASG" {
  launch_configuration = "${aws_launch_configuration.app-tier-launch-config.name}"
  vpc_zone_identifier  = ["${var.subnet1}","${var.subnet2 }"]
  target_group_arns    = ["${var.target_group_arn}"]
  health_check_type    = "ELB"

  min_size = 1
  max_size = 2

  tag {
    key                 = "Name"
    value               = "app-tier-asg"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "app-asg-sg" {
  name   = "app-asg-sg"
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "inbound_ssh" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.app-asg-sg.id}"
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "inbound_http" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.app-asg-sg.id}"
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "inbound_tcp" {
  from_port         = 8080
  protocol          = "tcp"
  security_group_id = "${aws_security_group.app-asg-sg.id}"
  to_port           = 8080
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_all" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.app-asg-sg.id}"
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

