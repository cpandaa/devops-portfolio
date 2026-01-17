output "storage_account_name" {
  value = module.storage.storage_account_name
}

output "sql_server_fqdn" {
  value = module.sql.sql_server_fqdn
}

output "sql_database_name" {
  value = module.sql.database_name
}
