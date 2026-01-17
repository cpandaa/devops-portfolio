resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "storage" {
  source               = "../../modules/storage-account"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = var.location
  storage_account_name = var.storage_account_name
  tags                 = var.tags
}

module "sql" {
  source              = "../../modules/sql-database"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sql_server_name     = var.sql_server_name
  admin_user          = var.sql_admin_user
  admin_password      = var.sql_admin_password
  tags                = var.tags
}
