provider "aws" {
  profile = "default"
  region  = "ap-southeast-1"

}
### Ec2 instance details 
resource "aws_instance" "webserver" {
  ami                         = "ami-082105f875acab993"
  instance_type               = "t2.micro"
  key_name                    = "forsingapore"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.sshport.id]
  user_data                   = <<-EOF
				#!/bin/bash
				sudo yum update -y
				sudo yum install httpd -y 
				sudo systemctl start httpd
				sudo echo "Welcome to Web Apache server-Terraform" > /var/www/html/index.html 
				EOF

  tags = {
    Name = "WebServer-1"
  }
}

### Security Group ####
### Allow inbound traffic - Port 22 for SSH from security group .

resource "aws_security_group" "sshport" {
  name        = "allow_web"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.singapore.id


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


## VPC singapore

resource "aws_vpc" "singapore" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "singapore"
  }
}

## Internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.singapore.id

  tags = {
    Name = "sing-IGW"
  }
}

## Public subnet

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.singapore.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-subnet"
  }
}


## Private subnet

resource "aws_subnet" "private-subnet" {
  vpc_id                  = aws_vpc.singapore.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private-subnet"
  }
}


## RT-public

resource "aws_route_table" "RT-public" {
  vpc_id = aws_vpc.singapore.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "RT-public"
  }
}

## aws_route_table_association

resource "aws_route_table_association" "pub-sub-route-assoc" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.RT-public.id
}

