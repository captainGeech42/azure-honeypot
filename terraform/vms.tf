resource  "azurerm_public_ip" "honeypot_ips" {
  for_each = var.azure_vms

  name                = "${each.key}-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network" "honeypot" {
  name                = "honeypot-network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  address_space = [ "10.0.0.0/8" ]
}

resource "azurerm_subnet" "honeypot_subnets" {
  for_each = var.azure_vms

  name                = "${each.key}-subnet"
  resource_group_name = azurerm_resource_group.rg.name

  virtual_network_name = "${each.key}-vnet"
  address_prefixes     = [ each.value["subnet"] ]
}

resource "azurerm_network_interface" "honeypot_nics" {
  for_each = var.azure_vms
  
  name                = "${each.key}-nic"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name = "public"
    subnet_id = azurerm_subnet.honeypot_subnets[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.honeypot_ips[each.key].id
  }
}

resource "azurerm_windows_virtual_machine" "honeypot_vms" {
  for_each = var.azure_vms

  name                = "${each.key}-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  
  size           = each.value["size"]
  admin_username = var.azure_vm_username
  admin_password = var.azure_vm_password
  computer_name  = each.value["vm_hostname"]

  network_interface_ids = [
    azurerm_network_interface.honeypot_nics[each.key].id
  ]

  os_disk {
    caching = "None"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}