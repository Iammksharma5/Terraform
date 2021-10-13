variable "ami" {
  default = "ami-082105f875acab993"

}
variable "instance_type" {
  default = "t2.micro"

}
variable "key_name" {
  default = "forsingapore"

}
variable "vpc-cidr" {
  default     = "19.0.0.0/16"
  description = "VPC CIDR Block-Singapore"

}
variable "public-cidr-block" {
  default = "19.0.3.0/24"

}

variable "private-cidr-block" {
  default = "19.0.6.0/24"

}

