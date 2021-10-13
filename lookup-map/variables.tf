variable "aws_region" {
  default = "us-east-1"
}

variable "key_name" {
  default = "northv"

}

variable "ssh-key" {
  type = map(any)
  default = {

    mumbai    = "Server-19"
    singapore = "forsingapore"
    london    = "eu-webkey"
    northv    = "us-webkey"
  }
}

variable "region_ami" {
  type = map(any)

  default = {
    ap-south-1     = "ami-0c1a7f89451184c8b"
    ap-southeast-1 = "ami-073998ba87e205747"
    eu-west-2      = "ami-02f5781cba46a5e8a"
    us-east-1      = "ami-02e136e904f3da870"
  }
}