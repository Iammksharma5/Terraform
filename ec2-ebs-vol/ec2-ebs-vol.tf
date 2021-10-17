provider "aws" {
  profile = "default"
  region  = "ap-south-1"

}


resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/xvde"
  volume_id   = aws_ebs_volume.myebsvol.id
  instance_id = aws_instance.web.id
}

resource "aws_instance" "web" {
  ami               = "ami-041d6256ed0f2061c"
  availability_zone = "ap-south-1a"
  instance_type     = "t2.micro"
  key_name          = "*****"  ### mention pem key name here.
  vpc_security_group_ids      = [aws_security_group.myWebSG.id]
  user_data                   = <<-EOF
				#!/bin/bash
				sudo yum update -y
				sudo yum install httpd -y 
				sudo systemctl start httpd
				sudo systemctl enable httpd
				sudo echo "Welcome to Mumbai Web Apache server-Terraform" > /var/www/html/index.html 
				EOF
  

  tags = {
    Name = "WebServer-5"
  }
}

resource "aws_security_group" "myWebSG" {
  name        = "allow_web"
  description = "Allow SSH inbound traffic"
  #vpc_id      = aws_vpc.myVPC.id

  ingress {
    description = "SSH "
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}


resource "aws_ebs_volume" "myebsvol" {
  availability_zone = "ap-south-1a"
  size              = 1
}