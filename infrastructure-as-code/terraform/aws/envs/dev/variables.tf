variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_profile" {
  type    = string
  default = "dev"
}

variable "name_prefix" {
  type    = string
  default = "tf-demo"
}

# You can pass existing VPC/Subnet IDs (common enterprise pattern).
variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "allowed_ssh_cidr" {
  type    = string
  default = "0.0.0.0/0" # tighten for real use
}

variable "tags" {
  type    = map(string)
  default = {
    Owner       = "platform"
    ManagedBy   = "terraform"
    Environment = "dev"
  }
}
