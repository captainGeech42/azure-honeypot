resource "azurerm_resource_group" "rg" {
  name     = var.azure_rg_name
  location = var.azure_region
}

resource "azurerm_storage_account" "sa" {
  name                = "${var.azure_sa_name}${random_integer.sa.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "ZRS"
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.azure_law_name}${random_integer.law.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku               = "PerGB2018"
  retention_in_days = 30
}

resource "azurerm_log_analytics_solution" "sentinel" {
  solution_name         = "SecurityInsights"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  workspace_resource_id = azurerm_log_analytics_workspace.law.id
  workspace_name        = azurerm_log_analytics_workspace.law.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }
}

resource "azurerm_log_analytics_linked_storage_account" "law_storage" {
  for_each = toset([ "customlogs", "query", "Ingestion", "alerts" ])

  data_source_type      = each.key
  resource_group_name   = azurerm_resource_group.rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.law.id
  storage_account_ids   = [ azurerm_storage_account.sa.id ]
}