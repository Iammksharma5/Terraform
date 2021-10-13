provider "aws" {
  profile = "default"
  region  = "ap-south-1"

}


resource "aws_s3_bucket" "MyWorkspacetestBuck-QA" {
  bucket = "myworkspacetestbuckqa"
  acl    = "public-read"

  tags = {
    Name        = "My bucket"
    Environment = "QA"
  }
}



resource "aws_iam_user" "Myuser2" {
 name = "marshal"
}