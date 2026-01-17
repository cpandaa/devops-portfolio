variable "name_prefix" {
  type = string
}

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
  type = string
}

variable "allowed_ssh_cidr" {
  type = string
}

variable "tags" {
  type = map(string)
}
