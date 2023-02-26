resource "random_id" "randomId" {
  keepers = {
    resource_group = azurerm_resource_group.lettyRG.name
  }

  byte_length = 8
}

resource "azurerm_storage_account" "vm-diag-storage-acc" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.lettyRG.name
  location                 = var.location
  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = {
    Purpose = "VM Boot Diagnostics"
  }
}