provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project = "terraform-ec2-simple"
      Owner   = "AdityaK"
      Env     = "dev"
    }
  }
}