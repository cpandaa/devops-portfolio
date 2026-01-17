variable "resource_group_name" {}
variable "location" {}
variable "sql_server_name" {}
variable "admin_user" {}
variable "admin_password" {
  sensitive = true
}
variable "tags" {
  type = map(string)
}
