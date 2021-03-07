output "honeypot_ips" {
  value = azurerm_public_ip.honeypot_ips
}

output "law_workspace_id" {
  value = azurerm_log_analytics_workspace.law.workspace_id
}

output "law_primary_shared_key" {
  value = azurerm_log_analytics_workspace.law.primary_shared_key
}

output "law_secondary_shared_key" {
  value = azurerm_log_analytics_workspace.law.secondary_shared_key
}