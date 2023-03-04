variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "vm_username" {}
variable "vm_password" {}

// Change Location if needed
variable "location" {
  default = "southeastasia"
}
// Main Spoke VNET for Letty
variable "vnetcidr" {
  default = "10.0.0.0/16"
}
// Hub VNET CIDR
variable "hubcidr" {
  default = "10.10.0.0/16"
}
// Web Subnet CIDR
variable "webcidr" {
  default = "10.0.10.0/24"
}
// DB Subnet CIDR
variable "dbcidr" {
  default = "10.0.20.0/24"
}
// Bastion Subnet CIDR
variable "bastioncidr" {
  default = "10.10.100.0/24"
}
// Azure Firewall IP
variable "firewallPvtIP" {
  default = "10.10.0.4"
}
// Application Gateway Backend Pool
variable "appGWbackendpool1" {
  default = "10.0.10.10"
}