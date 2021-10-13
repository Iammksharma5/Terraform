resource "aws_s3_bucket" "s3" {
  bucket = var.bucket
  acl    = "private"
}


#terraform {

# backend "s3" {
# bucket = "myterrastatebackend21"
# key    = "terraform.tfstate"
#acl    = "public-read"
# region = "ap-south-1"
#}
#}

### Ec2 instance details 
resource "aws_instance" "webserver" {
  ami                         = "ami-0a23ccb2cdd9286bb"
  instance_type               = "t2.micro"
  key_name                    = "Webserver"
  associate_public_ip_address = true
  user_data                   = <<-EOF
				#!/bin/bash
				sudo yum update -y
				sudo yum install httpd -y 
				sudo systemctl start httpd
				sudo echo "Welcome to MyApache server" > /var/www/html/index.html 
				EOF

  tags = {
    Name = "WebServer-1"
  }
}




output "s2_output-id" {
  value = aws_s3_bucket.s3.id

}

output "s3_output-acl" {
  value = aws_s3_bucket.s3.acl
}

output "s3_output-region" {
  value = aws_s3_bucket.s3.region
}


output "ec2-instance-id" {
  value = aws_instance.webserver.id
} 