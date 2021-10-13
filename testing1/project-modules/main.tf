provider "aws" {
  profile = "default"
  region  = "ap-south-1"

}

module "mumbai-ec2" {
  source             = "E:/IT-Cloud/Terraform/testing1/project-modules/modules/ec2/ec2-mumbai"

}


#module "ec2-singapore" {
# source = "E:/IT-Cloud/Terraform/testing1/project-modules/modules/ec2/ec2-singapore"

#}

