### EC instance in Singapore Region

resource "aws_instance" "ec2-singapore" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  associate_public_ip_address = true
  provider = aws.web
  subnet_id                   = aws_subnet.PublicSub.id
  vpc_security_group_ids = [aws_security_group.myWebSG.id]
   tags = {
    Name = "WebServer-2-singapore"
  }
}


## Security Group
resource "aws_security_group" "myWebSG" {
### Allow inbound traffic - Port 22 for SSH from security group .

resource "aws_security_group" "myWebSG" {
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
  cidr_block           = var.vpc-cidr
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

resource "aws_subnet" "PublicSub" {
  vpc_id                  = aws_vpc.mySG-VPC.id
  map_public_ip_on_launch = true
  availability_zone       = "ap-southeast-1a"
  provider = aws.web
  cidr_block              = var.public-cidr-block

  tags = {
    Name = "Public-Subnet"
  }
}

### Private Subnet of Singapore Region

resource "aws_subnet" "PrivateSub" {
  vpc_id     = aws_vpc.mySG-VPC.id
  cidr_block = var.private-cidr-block
  provider = aws.web
  availability_zone       = "ap-southeast-1b"

  tags = {
    Name = "Private-Subnet"
  }
}


## RT-public

resource "aws_route_table" "RT-public-sg" {
  vpc_id = aws_vpc.mySG-VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    provider = aws.web
    gateway_id = aws_internet_gateway.Singa-gw.id
  }

  tags = {
    Name = "RT-public"
  }
}

## aws_route_table_association

resource "aws_route_table_association" "pub-sub-route-assoc" {
  subnet_id      = aws_subnet.PublicSub.id
  route_table_id = aws_route_table.RT-public-sg.id
  provider = aws.web
}

}