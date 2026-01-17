provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "web" {
  source = "../../modules/ec2-web"

  name_prefix     = var.name_prefix
  vpc_id          = var.vpc_id
  subnet_id       = var.subnet_id
  key_name        = var.key_name
  instance_type   = var.instance_type
  allowed_ssh_cidr = var.allowed_ssh_cidr
  tags            = var.tags
}
