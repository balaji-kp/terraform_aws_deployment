resource "aws_instance" "jumpserver" {
 ami = "ami-0d378460834b1dd3b"
 instance_type = "t2.micro"
 vpc_security_group_ids = [var.webSG]
 subnet_id = var.public-subnet
 key_name = "WEBSERVER"
 user_data = <<-EOF
	#!/bin/bash
	#sudo apt update -y
	#sudo apt install nginx -y
	#sudo rm -rf /var/www/html
	#sudo git clone https://github.com/balaji-kp/react-prod-build.git
	#sudo mv react-prod-build/ html/
    cd /var/www/html/static/js/
	#export app-tier-alb-endpoint="http://balaji.com"
	sed -Ei 's|baseURL=\"http[s]?:\/\/[^[:space:];]+|baseURL="http://'${var.app-tier-alb-endpoint}'"|g' main.47beb5e0.js
	sudo systemctl restart nginx
 	EOF
 user_data_replace_on_change = true
 tags = {
 Name = "terraform-webserver"
 }
 
}

resource "aws_instance" "webserver1" {
 ami = "ami-0d378460834b1dd3b"
 instance_type = "t2.micro"
 vpc_security_group_ids = [var.webSG]
 subnet_id = var.web-tier-sub1
 key_name = "WEBSERVER"
 user_data = <<-EOF
	#!/bin/bash
	#sudo apt update -y
	#sudo apt install nginx -y
	#sudo rm -rf /var/www/html
	#sudo git clone https://github.com/balaji-kp/react-prod-build.git
	#sudo mv react-prod-build/ html/
    cd /var/www/html/static/js/
	#export app-tier-alb-endpoint="http://balaji.com"
	sed -Ei 's|baseURL=\"http[s]?:\/\/[^[:space:];]+|baseURL="http://'${var.app-tier-alb-endpoint}'"|g' main.47beb5e0.js
	sudo systemctl restart nginx
 	EOF
 user_data_replace_on_change = true
 tags = {
 Name = "terraform-webserver"
 }
 
}

resource "aws_instance" "webserver2" {
 ami = "ami-0d378460834b1dd3b"
 instance_type = "t2.micro"
 vpc_security_group_ids = [var.webSG]
 subnet_id = var.web-tier-sub2
 key_name = "WEBSERVER"
 user_data = <<-EOF
	#!/bin/bash
	#sudo apt update -y
	#sudo apt install nginx -y
	#sudo rm -rf /var/www/html
	#sudo git clone https://github.com/balaji-kp/react-prod-build.git
	#sudo mv react-prod-build/ html/
    cd /var/www/html/static/js/
	#export app-tier-alb-endpoint="http://balaji.com"
	sed -Ei 's|baseURL=\"http[s]?:\/\/[^[:space:];]+|baseURL="http://'${var.app-tier-alb-endpoint}'"|g' main.47beb5e0.js
	sudo systemctl restart nginx
 	EOF
 user_data_replace_on_change = true
 tags = {
 Name = "terraform-webserver"
 }
 
}

resource "aws_instance" "appserver1" {
 ami = "ami-03f4878755434977f"
 instance_type = "t2.micro"
 vpc_security_group_ids = [var.webSG]
 key_name = "WEBSERVER"
 subnet_id = var.web-tier-sub1
   iam_instance_profile {
    name = var.ec2_s3_role_name
  }
 user_data = <<-EOF
 	#!/bin/bash
	echo export FRONTEND_ENDPOINT= ${var.web-tier-alb-endpoint} >> ~/.bashrc
	export FRONTEND_ENDPOINT= ${var.web-tier-alb-endpoint}
	echo export DB_URL=${var.rds-endpoint} >> ~/.bashrc
	source ~/.bashrc
	export DB_URL=${var.rds-endpoint}
	source ~/.bashrc
	sudo apt update -y
	sudo apt install openjdk-17-jre-headless -y
	sudo apt install awscli -y
	sudo aws s3 cp s3://my-springboot-artifact/springboot-Mysql-loginpageDemo.jar .
	nohup java -jar springboot-Mysql-loginpageDemo.jar >>/tmp/ouput.log &
 	EOF
 user_data_replace_on_change = true
 tags = {
 Name = "terraform-APPserver-s3-access"
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
	export FRONTEND_ENDPOINT= ${var.web-tier-alb-endpoint}
	export DB_URL=${var.rds-endpoint}
	source ~/.bashrc
	nohup java -jar /home/ubuntu/springboot-react-fullstack-backend/target/springboot-Mysql-loginpageDemo.jar >>/tmp/ouput.log &
 	EOF
 user_data_replace_on_change = true
 tags = {
 Name = "terraform-APPserver"
 }
}


