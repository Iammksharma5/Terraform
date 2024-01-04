# Configure the AWS Provider
provider "aws" {
  region  = "ap-south-1"
  profile = "default"
}
resource "aws_s3_bucket" "mystatefile" {
  bucket = "bucketforstate2024"
  tags = {
    name = "terraform_statebackup"
    Env  = "dev"
  }
}
resource "aws_s3_bucket_versioning" "ver" {
  bucket = aws_s3_bucket.terra_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
#EC2 region mum
resource "aws_instance" "mumbai" {
  ami           = "ami-08fe36427228eddc4"
  instance_type = "t2.micro"
  key_name      = "terkey"
  tags = {
    Name = "webserver_mumbai"
    Envo = "Linux"
  }
}