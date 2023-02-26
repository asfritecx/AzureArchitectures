variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "vm_username" {}
variable "vm_password" {}

variable "location" {
  default = "southeastasia"
}

variable "vnetcidr" {
  default = "10.0.0.0/16"
}

variable "hubcidr" {
  default = "10.10.0.0/16"
}

variable "webcidr" {
  default = "10.0.10.0/24"
}

variable "dbcidr" {
  default = "10.0.20.0/24"
}

variable "bastioncidr" {
  default = "10.10.100.0/24"
}

variable "firewallPvtIP" {
  default = "10.10.0.4"
}
