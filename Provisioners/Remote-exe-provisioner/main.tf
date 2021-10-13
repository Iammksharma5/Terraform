provider "aws" {
  profile = "default"
  region  = "ap-south-1"

}

resource "aws_instance" "web" {
  ami                    = "ami-0a23ccb2cdd9286bb"
  instance_type          = "t2.micro"
  key_name               = "Server-19"
  user_data              = file("httpd.sh")
  vpc_security_group_ids = ["${aws_security_group.webSG.id}"]
  tags = {
    Name = "Remote-file-provisioner"
  }

}



resource "aws_security_group" "webSG" {
  name        = "webSG"
  description = "Allow ssh  inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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

resource "null_resource" "copyexecute" {

  connection {
    type        = "ssh"
    host        = aws_instance.web.public_ip
    user        = "ec2-user"
    private_key = file("Server-19.pem")
  }

  provisioner "file" {
    source      = "httpd.sh"
    destination = "/tmp/httpd.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/httpd.sh",
      "sudo /tmp/httpd.sh args",
    ]
  }

  depends_on = [aws_instance.web]

}