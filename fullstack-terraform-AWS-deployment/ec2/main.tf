resource "aws_instance" "webserver" {
 ami = "ami-0107e1ad00c66f499"
 instance_type = "t2.micro"
 vpc_security_group_ids = [aws_security_group.websg.id]
 key_name = "WEBSERVER"
 user_data = <<-EOF
 	#!/bin/bash
	export BACKEND_URL=http://app-tier-alb-696022083.ap-south-1.elb.amazonaws.com
	cd /home/ubuntu/springboot-react-fullstack-frontend
	npm run build
	cp -r ./build/ /var/www/html/build/
	systemctl restart nginx
	systemctl enable nginx
 	EOF
 user_data_replace_on_change = true
 tags = {
 Name = "terraform-webserver"
 }
 
}

resource "aws_instance" "appserver" {
 ami = "ami-05176e024d4607c6b"
 instance_type = "t2.micro"
 vpc_security_group_ids = [aws_security_group.websg.id]
 key_name = "WEBSERVER"
 user_data = <<-EOF
 	#!/bin/bash
	export FRONTEND_ENDPOINT=web-tier-alb-11645959.ap-south-1.elb.amazonaws.com
	export DB_URL=database-1.ctap86niaksk.ap-south-1.rds.amazonaws.com
	cd /home/ubuntu/springboot-react-fullstack-backend/target
	java -jar springboot-Mysql-loginpageDemo.jar --server.port=80
 	EOF
 user_data_replace_on_change = true
 tags = {
 Name = "terraform-APPserver"
 }
}


resource "aws_security_group" "webSg" {
  name   = "web"
  vpc_id = var.myvpc

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-sg"
  }
}