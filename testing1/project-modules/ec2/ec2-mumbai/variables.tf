variable "ami" {
  default = "ami-0a23ccb2cdd9286bb"

}
variable "instance_type" {
  default = "t2.micro"

}
variable "key_name" {
  default = "Webserver"

}
variable "vpc-cidr" {
  default     = "12.0.0.0/16"
  description = "VPC CIDR Block-Mumbai"

}
variable "public-cidr-block" {
  default = "12.0.1.0/24"

}

variable "private-cidr-block" {
  default = "12.0.6.0/24"

}

