resource "azurerm_windows_virtual_machine" "LAPP01" {
  name                     = "LAPP01"
  resource_group_name      = azurerm_resource_group.lettyRG.name
  location                 = azurerm_resource_group.lettyRG.location
  size                     = "Standard_B2s"
  admin_username           = var.vm_username
  admin_password           = var.vm_password
  enable_automatic_updates = false
  patch_mode               = "Manual"
  network_interface_ids = [
    azurerm_network_interface.webserverNIC.id,
  ]

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.vm-diag-storage-acc.primary_blob_endpoint
  }

  os_disk {

    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter-Azure-Edition"
    version   = "latest"
  }

  tags = {
    "Purpose" = "Letty Application Server"
  }

}

resource "azurerm_windows_virtual_machine" "LDB01" {
  name                = "LDB01"
  resource_group_name = azurerm_resource_group.lettyRG.name
  location            = azurerm_resource_group.lettyRG.location
  size                = "Standard_B2s"
  admin_username      = var.vm_username
  admin_password      = var.vm_password

  network_interface_ids = [
    azurerm_network_interface.dbserverNIC.id,
  ]

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.vm-diag-storage-acc.primary_blob_endpoint
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter-Azure-Edition"
    version   = "latest"
  }

  tags = {
    "Purpose" = "Letty Database Server"
  }

}