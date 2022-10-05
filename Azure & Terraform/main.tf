terraform {
  required_version = "1.2.8"   
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.20.0"
    }
  }
}
# Providers and credentials
provider "azurerm" {
    features {}

  subscription_id = ""
  client_id       = ""
  client_secret   = ""
  tenant_id       = ""
}
# We are creating a resource group
 resource "azurerm_resource_group" "example" {
   name     = "acctestrg"
   location = "North Europe"
 }
# We are creating a network
resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}
# We are creating a subnet
resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}
# We are creating an IP (for Load Balancer)
 resource "azurerm_public_ip" "example" {
   name                         = "publicIPForLB"
   location                     = azurerm_resource_group.example.location
   resource_group_name          = azurerm_resource_group.example.name
   allocation_method            = "Static"
   sku = "Standard"
 }
 # We are creating a Load Balancer and ip-config
 resource "azurerm_lb" "example" {
   name                = "loadBalancer"
   location            = azurerm_resource_group.example.location
   resource_group_name = azurerm_resource_group.example.name
   sku = "Standard"
      
   frontend_ip_configuration {
     name                 = "publicIPAddress"
     public_ip_address_id = azurerm_public_ip.example.id
   }
 }
 # We are creating a BackendPool
 resource "azurerm_lb_backend_address_pool" "example" {
   loadbalancer_id     = azurerm_lb.example.id
   name                = "BackEndAddressPool"
 }
 # We are creating a Health Probe
 resource "azurerm_lb_probe" "example" {
  loadbalancer_id = azurerm_lb.example.id
  name            = "example-prob"
  port            = 80
}
# We are creating a network interfaces for VM`s
resource "azurerm_network_interface" "example" {
  count=2
  name                = "example-nic${count.index}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}
# We are creating a virtual machines
resource "azurerm_windows_virtual_machine" "example" {
  #count=2
  name                = "machine${each.value}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_F2"
  for_each = local.zones
  zone = each.value
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [element(azurerm_network_interface.example.*.id, each.value)]
  

  
    os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
   }
}

locals {
  zones = toset(["1","2"])
}
# We are creating a Security group
resource "azurerm_network_security_group" "example_nsg" {
  name                = "app-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

# We are creating a rule to allow traffic on port 80
  security_rule {
    name                       = "Allow_HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
# We are adding a VM`s to Backend Pool
 resource "azurerm_lb_backend_address_pool_address" "example" {
  name                    = "example"
  backend_address_pool_id = azurerm_lb_backend_address_pool.example.id
  virtual_network_id      = azurerm_virtual_network.example.id
  ip_address              = azurerm_network_interface.example.0.private_ip_address

  depends_on = [
    azurerm_lb_backend_address_pool.example
  ]
   
} 

resource "azurerm_lb_backend_address_pool_address" "example1" {
  name                    = "example1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.example.id
  virtual_network_id      = azurerm_virtual_network.example.id
  ip_address              = azurerm_network_interface.example.1.private_ip_address

   depends_on = [
    azurerm_lb_backend_address_pool.example
  ] 
} 
# We are creating a rules for LB
resource "azurerm_lb_rule" "example" {
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "example-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "publicIPAddress"
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.example.id]
  probe_id = azurerm_lb_probe.example.id
}
# We are creating a storage
resource "azurerm_storage_account" "appstore" {
  name                     = "store1337qweasd"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
}
# We are creating a container for storage with our config
resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = "store1337qweasd"
  container_access_type = "blob"
  depends_on=[
    azurerm_storage_account.appstore
    ]
}

resource "azurerm_storage_blob" "IIS_config" {
  name                   = "IIS_Config.ps1"
  storage_account_name   = "store1337qweasd"
  storage_container_name = "data"
  type                   = "Block"
  source                 = "IIS_Config.ps1"
   depends_on=[azurerm_storage_container.data]
}
# We are creating a VM extensions to automate a WebServer deployment
resource "azurerm_virtual_machine_extension" "vm_extension1" {
  for_each = azurerm_windows_virtual_machine.example
  name                 = "appvm-extension"
  virtual_machine_id   = azurerm_windows_virtual_machine.example[each.key].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  depends_on = [
    azurerm_storage_blob.IIS_config
  ]
  settings = <<SETTINGS
    {
        "fileUris": ["https://${azurerm_storage_account.appstore.name}.blob.core.windows.net/data/IIS_Config.ps1"],
          "commandToExecute": "powershell -ExecutionPolicy Unrestricted -file IIS_Config.ps1"     
    }
SETTINGS
}