
provider "aws" {
  profile = "default"
  region  = "ap-south-1"
}


provider "aws" {
  profile = "default"
  alias   = "web"
  region  = "ap-southeast-1"
}

### EC2 - Region Mumbai


resource "aws_instance" "ec2-mum" {
  ami                         = "ami-0a23ccb2cdd9286bb"
  instance_type               = "t2.micro"
  key_name                    = "Server-19"
  #count		      = 2
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.PublicSub.id
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
    Name = "WebServer-1"
  }
}





### Security Group ####
### Allow inbound traffic - Port 22 for SSH from security group .

resource "aws_security_group" "myWebSG" {
  name        = "allow_web"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.myVPC.id

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
 


#### VPC of Mumabi Region


resource "aws_vpc" "myVPC" {

  cidr_block           = var.vpc-cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "MyVPC-Mumbai"
  }
}

### Internet Gateway

resource "aws_internet_gateway" "Mum-gw" {
  vpc_id = aws_vpc.myVPC.id

  tags = {
    Name = "internet-gateway-Mumbai"
  }
}



## Public Subnet of Mumabi Region

resource "aws_subnet" "PublicSub" {
  vpc_id                  = aws_vpc.myVPC.id
  map_public_ip_on_launch = true
  cidr_block              = var.public-cidr-block
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "Public-Subnet"
  }
}
### Private Subnet of Mumabi Region

resource "aws_subnet" "PrivateSub" {
  vpc_id            = aws_vpc.myVPC.id
  cidr_block        = var.private-cidr-block
  availability_zone = "ap-south-1b"
  tags = {
    Name = "Private-Subnet"
  }
}



## RT-public

resource "aws_route_table" "RT-public" {
  vpc_id = aws_vpc.myVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Mum-gw.id
  }

  tags = {
    Name = "RT-public"
  }
}

## aws_route_table_association

resource "aws_route_table_association" "pub-sub-route-assoc" {
  subnet_id      = aws_subnet.PublicSub.id
  route_table_id = aws_route_table.RT-public.id
}







### EC2 - Region Singapore 


resource "aws_instance" "webserver" {
  ami                         = var.image
  instance_type               = var.instance_t
  key_name                    = var.key-ssh
  provider		      = aws.web
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.PublicSubSinga.id
  vpc_security_group_ids      = [aws_security_group.SingaSG.id]
  user_data                   = <<-EOF
				#!/bin/bash
				sudo yum update -y
				sudo yum install httpd -y 
				sudo systemctl start httpd
				sudo systemctl enable httpd
				sudo echo "Welcome to Singapore Web Apache server-Terraform" > /var/www/html/index.html 
				EOF

  tags = {
    Name = "WebServer-2"
  }
}



## Security Group
### Allow inbound traffic - Port 22 for SSH from security group .

resource "aws_security_group" "SingaSG" {
  name        = "allow_web-sg"
  description = "Allow SSH inbound traffic"
  provider = aws.web
  vpc_id      = aws_vpc.mySG-VPC.id

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

### VPC of Singapore Region

resource "aws_vpc" "mySG-VPC" {
  cidr_block           = var.vpc-mycidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  provider = aws.web
  tags = {
    Name = "MyVPC-Singapore"
  }
}

### Internet Gateway

resource "aws_internet_gateway" "Singa-gw" {
  vpc_id = aws_vpc.mySG-VPC.id
  provider = aws.web	
  tags = {
    Name = "internet-gateway-Singapore"
  }
}

### Public Subnet of Singapore Region

resource "aws_subnet" "PublicSubSinga" {
  vpc_id                  = aws_vpc.mySG-VPC.id
  map_public_ip_on_launch = true
  availability_zone       = "ap-southeast-1a"
  provider = aws.web
  cidr_block              = var.public-cidr

  tags = {
    Name = "Public-Subnet"
  }
}

### Private Subnet of Singapore Region

resource "aws_subnet" "PrivateSubSinga" {
  vpc_id     = aws_vpc.mySG-VPC.id
  cidr_block = var.private-cidr
  provider = aws.web
  availability_zone       = "ap-southeast-1b"

  tags = {
    Name = "Private-Subnet"
  }
}


## RT-public

resource "aws_route_table" "RT-public-sg-singa" {
  provider = aws.web
  vpc_id =  aws_vpc.mySG-VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Singa-gw.id
  }

  tags = {
    Name = "RT-public"
  }
}

## aws_route_table_association

resource "aws_route_table_association" "pubsub-route-assoc" {
	provider = aws.web  
	subnet_id      = aws_subnet.PublicSubSinga.id
  	route_table_id = aws_route_table.RT-public-sg-singa.id
  
}

