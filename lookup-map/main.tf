provider "aws" {
  profile = "default"
  region  = var.aws_region

}

resource "aws_instance" "webserver" {
  ami           = lookup(var.region_ami, var.aws_region)
  key_name      = lookup(var.ssh-key, var.key_name)
  instance_type = "t2.micro"
  tags = {
    Name = "WebWorld"
  }

}