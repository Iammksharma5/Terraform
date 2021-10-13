provider "aws" {
  profile = "default"
  region  = "ap-south-1"

}

resource "aws_instance" "web" {
  ami                    = "ami-0a23ccb2cdd9286bb"
  instance_type          = "t2.micro"
  key_name               = "Server-19"
  #user_data              = file("httpd.sh")
  #vpc_security_group_ids = ["${aws_security_group.webSG.id}"]
  provisioner "local-exec" {
    command = "echo ${aws_instance.web.private_ip} >> private_ips.txt"
  }
  tags = {
    Name = "Local-exec-provisioner"
  }

}
