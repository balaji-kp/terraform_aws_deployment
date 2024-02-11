resource "aws_instance" "webserver1" {
 ami = "ami-0107e1ad00c66f499"
 instance_type = "t2.micro"
 vpc_security_group_ids = [var.webSG]
 subnet_id = var.web-tier-sub1
 key_name = "WEBSERVER"
 user_data = <<-EOF
 	#!/bin/bash
	cd var/www/html
	rm -rf build/
	git clone https://github.com/balaji-kp/react-prod-build.git
	mv react-prod-build/ build
	systemctl restart nginx
	sleep 3
 	EOF
 user_data_replace_on_change = true
 tags = {
 Name = "terraform-webserver"
 }
 
}

resource "aws_instance" "webserver2" {
 ami = "ami-0107e1ad00c66f499"
 instance_type = "t2.micro"
 vpc_security_group_ids = [var.webSG]
 subnet_id = var.web-tier-sub2
 key_name = "WEBSERVER"
 user_data = <<-EOF
 	#!/bin/bash
	cd var/www/html
	rm -rf build/
	git clone https://github.com/balaji-kp/react-prod-build.git
	rm -rf build/
	mv react-prod-build/ build
	systemctl restart nginx
	sleep 3
 	EOF
 user_data_replace_on_change = true
 tags = {
 Name = "terraform-webserver"
 }
 
}

resource "aws_instance" "appserver1" {
 ami = "ami-05176e024d4607c6b"
 instance_type = "t2.micro"
 vpc_security_group_ids = [var.webSG]
 key_name = "WEBSERVER"
 subnet_id = var.app-tier-sub1
 user_data = <<-EOF
 	#!/bin/bash
	echo export FRONTEND_ENDPOINT= ${var.web-tier-alb-endpoint} >> ~/.bashrc
	echo export DB_URL=${var.rds-endpoint} >> ~/.bashrc
	source ~/.bashrc
	nohup java -jar /home/ubuntu/springboot-react-fullstack-backend/target/springboot-Mysql-loginpageDemo.jar --server.port=80 >>/tmp/ouput.log &
 	EOF
 user_data_replace_on_change = true
 tags = {
 Name = "terraform-APPserver"
 }
}

resource "aws_instance" "appserver2" {
 ami = "ami-05176e024d4607c6b"
 instance_type = "t2.micro"
 vpc_security_group_ids = [var.webSG]
 key_name = "WEBSERVER"
 subnet_id = var.app-tier-sub2
 user_data = <<-EOF
 	#!/bin/bash
	echo export FRONTEND_ENDPOINT= ${var.web-tier-alb-endpoint} >> ~/.bashrc
	echo export DB_URL=${var.rds-endpoint} >> ~/.bashrc
	echo export FRONTEND_ENDPOINT= ${var.web-tier-alb-endpoint} >> ~/.profile`
	echo export DB_URL=${var.rds-endpoint} >> ~/.profile
	source ~/.bashrc
	source ~/.profile
	nohup java -jar /home/ubuntu/springboot-react-fullstack-backend/target/springboot-Mysql-loginpageDemo.jar --server.port=80 >>/tmp/ouput.log &
 	EOF
 user_data_replace_on_change = true
 tags = {
 Name = "terraform-APPserver"
 }
}


