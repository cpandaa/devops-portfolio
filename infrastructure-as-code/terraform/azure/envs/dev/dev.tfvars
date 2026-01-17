resource_group_name  = "rg-tf-dev"
storage_account_name = "tfdemostorage123"
sql_server_name      = "tf-sql-dev-01"
sql_admin_user       = "sqladmin"
sql_admin_password   = "ChangeMeStrongPassword123!"

tags = {
  Environment = "dev"
  ManagedBy   = "terraform"
}
