provider "aws" {
  version = "~> 2.63.0"
  profile = var.aws_profile
  region  = var.region
}
