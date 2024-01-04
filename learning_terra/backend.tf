terraform {
  backend "s3" {
    region = "ap-south-1"
    bucket = "bucketforstate2024"
    key    = "tf_state_main/terraform.tfstate"
    dynamodb_table = "terraform_state_monitor"
  }
}
#DYnomo DB
resource "aws_dynamodb_table" "terraform-lock" {
  name           = "terraform_state_monitor"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    "Name" = "DynamoDB Terraform State Lock Table"
  }
}