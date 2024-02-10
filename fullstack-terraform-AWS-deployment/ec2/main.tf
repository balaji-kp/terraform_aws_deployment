resource "aws_instance" "webserver1" {
 ami = "ami-0107e1ad00c66f499"
 instance_type = "t2.micro"
 vpc_security_group_ids = [var.webSG]
 subnet_id = var.web-tier-sub1
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

resource "aws_instance" "webserver2" {
 ami = "ami-0107e1ad00c66f499"
 instance_type = "t2.micro"
 vpc_security_group_ids = [var.webSG]
 subnet_id = var.web-tier-sub1
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


