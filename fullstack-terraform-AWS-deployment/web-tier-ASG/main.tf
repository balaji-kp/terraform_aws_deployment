resource "aws_launch_configuration" "web-tier-launch-config" {
  image_id        = "ami-0107e1ad00c66f499"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.my-asg-sg.id}"]

  user_data = <<-EOF
 	#!/bin/bash
	cd var/www/html
	git clone https://github.com/balaji-kp/react-prod-build.git
	rm -rf build/
	mv react-prod-build/ build
	sleep 2
    EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web-tier-ASG" {
  launch_configuration = "${aws_launch_configuration.web-tier-launch-config.name}"
  vpc_zone_identifier  = ["${var.subnet1}","${var.subnet2 }"]
  target_group_arns    = ["${var.target_group_arn}"]
  health_check_type    = "ELB"

  min_size = 2
  max_size = 4

  tag {
    key                 = "Name"
    value               = "web-tier-asg"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "my-asg-sg" {
  name   = "my-asg-sg"
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "inbound_ssh" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.my-asg-sg.id}"
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "inbound_http" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.my-asg-sg.id}"
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_all" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.my-asg-sg.id}"
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}