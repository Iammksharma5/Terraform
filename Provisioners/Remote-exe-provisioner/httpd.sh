#!/bin/bash
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo echo "welcome to terraform mytest" > /var/www/html/index.html
sudo systemctl reload httpd