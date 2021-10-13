terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 3.62.0"
      configuration_aliases = [aws.web]
    }
  }
}



provider "aws" {
  profile = "default"
  alias   = "web"
  region  = "ap-southeast-1"
}
