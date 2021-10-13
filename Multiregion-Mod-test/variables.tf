# For Mumbai Region

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




## For singapore region 

variable "image" {
  default = "ami-082105f875acab993"

}
variable "instance_t" {
  default = "t2.micro"

}
variable "key-ssh" {
  default = "forsingapore"

}
variable "vpc-mycidr" {
  default     = "19.0.0.0/16"
  description = "VPC CIDR Block-Singapore"

}
variable "public-cidr" {
  default = "19.0.3.0/24"

}

variable "private-cidr" {
  default = "19.0.6.0/24"

}