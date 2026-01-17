variable "location" {
  default = "East US"
}

variable "resource_group_name" {}
variable "storage_account_name" {}
variable "sql_server_name" {}
variable "sql_admin_user" {}
variable "sql_admin_password" {
  sensitive = true
}
variable "tags" {
  type = map(string)
}
