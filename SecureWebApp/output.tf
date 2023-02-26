output "App-Gateway-PublicIP" {
  value = azurerm_public_ip.appGWPIP.ip_address
}
output "Azure-Firewall-PublicIP" {
  value = azurerm_public_ip.lettyFirewallPIP.ip_address
}