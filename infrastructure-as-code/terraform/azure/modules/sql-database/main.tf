resource "azurerm_mssql_server" "this" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.admin_user
  administrator_login_password = var.admin_password
  tags = var.tags
}

resource "azurerm_mssql_database" "this" {
  name      = "appdb"
  server_id = azurerm_mssql_server.this.id
  sku_name  = "Basic"
  tags      = var.tags
}
