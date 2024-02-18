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