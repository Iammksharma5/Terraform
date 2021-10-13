
##############  alias: Multiple Provider Configurations


this is for meta-argument "alias". with the help of alias you can create resources in multiple region from  single configuration file.





alias: Multiple Provider Configurations
You can optionally define multiple configurations for the same provider, and select which one to use on a per-resource or per-module basis. The primary reason for this is to support multiple regions for a cloud platform; other examples include targeting multiple Docker hosts, multiple Consul hosts, etc.

To create multiple configurations for a given provider, include multiple provider blocks with the same provider name. For each additional non-default configuration, use the alias meta-argument to provide an extra name segment. For example:

# The default provider configuration; resources that begin with `aws_` will use
# it as the default, and it can be referenced as `aws`.


provider "aws" {
  region = "us-east-1"
}

# Additional provider configuration for west coast region; resources can
# reference this as `aws.west`.
provider "aws" {
  alias  = "west"
  region = "us-west-2"
}