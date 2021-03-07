resource "azurerm_resource_group" "rg" {
  name     = var.azure_rg_name
  location = var.azure_region
}

resource "azurerm_storage_account" "sa" {
  name                = "${var.azure_sa_name}-${random_integer.sa}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "ZRS"
}