# --- Optional: Create an EC2 key pair from your local public key if key_name is empty ---
# This uses: ./AdityaSSHkey.pub
resource "aws_key_pair" "aditya" {
  count      = var.key_name == "" ? 1 : 0
  key_name   = "AdityaKey"
  public_key = file("${path.root}/AdityaSSHkey.pub")
  tags       = var.tags
}

locals {
  effective_key_name = var.key_name != "" ? var.key_name : one(aws_key_pair.aditya[*].key_name)
}

module "vpc" {
  source         = "./modules/vpc-creation"
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  azs            = var.azs
  tags           = var.tags
}

module "ec2" {
  source           = "./modules/ec2_creation"
  vpc_id           = module.vpc.vpc_id
  subnet_id        = module.vpc.public_subnet_ids["public-a"]
  instance_type    = var.instance_type
  key_name         = local.effective_key_name
  ingress_ssh_cidr = var.ingress_ssh_cidr
  tags             = merge(var.tags, { Name = "${var.tags["Project"]}-web-1" })
}
module "s3_bucket" {
  source = "./modules/s3-bucket"

  bucket_name         = var.s3_bucket_name
  environment         = var.environment
  enable_versioning   = true
  block_public_access = true

  tags = merge(var.tags, {
    Service = "storage"
  })
}