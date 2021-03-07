output "honeypot_ips" {
  for_each = var.azure_vms

  value = azurerm_public_ip.honeypot_ips[each.key].ip_address
}