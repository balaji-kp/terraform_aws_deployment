	#!/bin/bash
	sudo su
	echo export FRONTEND_ENDPOINT= ${var.web-tier-alb-endpoint} >> /etc/environment
	echo export DB_URL= ${var.rds-endpoint} >> /etc/environment
	export FRONTEND_ENDPOINT= ${var.rds-endpoint}
	export DB_URL=${var.rds-endpoint}
	source /etc/environment
	dnf update -y
	dnf install java-17-amazon-corretto -y
	aws s3 cp s3://my-springboot-artifact/springboot-Mysql-loginpageDemo.jar /
	java -jar /springboot-Mysql-loginpageDemo.jar >>/tmp/ouput.log &