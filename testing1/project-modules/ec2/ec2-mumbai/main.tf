
### EC instance in Mumbai Region

resource "aws_instance" "ec2-mum" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.PublicSub.id
  vpc_security_group_ids      = [aws_security_group.myWebSG.id]

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
