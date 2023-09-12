locals {
  location = "UK South"
  rg_name  = "dis-2023"
  size = "Standard_B4ms"
  vm_name = "tocode"
  username = "adminuser"
}

variable "email" {}
variable "api_token" {}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "=3.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_virtual_network" "tocode" {
  name                = "${local.vm_name}_network"
  address_space       = ["10.0.0.0/16"]
  location            = local.location
  resource_group_name = local.rg_name
}

resource "azurerm_subnet" "tocode" {
  name                 = "${local.vm_name}_subnet"
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.tocode.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "tocode" {
  subnet_id                 = azurerm_subnet.tocode.id
  network_security_group_id = azurerm_network_security_group.tocode.id
}

resource "azurerm_network_interface" "tocode" {
  name                = "${local.vm_name}_interface"
  location            = local.location
  resource_group_name = local.rg_name

  ip_configuration {
    name                          = "${local.vm_name}_ip"
    subnet_id                     = azurerm_subnet.tocode.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tocode.id
  }
}

resource "azurerm_public_ip" "tocode" {
  name                    = "${local.vm_name}_public_ip"
  location                = local.location
  resource_group_name     = local.rg_name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
}

resource "azurerm_network_security_group" "tocode" {
  name                = "${local.vm_name}_security_group"
  location            = local.location
  resource_group_name = local.rg_name

  security_rule {
    name                       = "https"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "ssh"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "http"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_linux_virtual_machine" "tocode" {
  name                = local.vm_name
  resource_group_name = local.rg_name
  location            = local.location
  size                = local.size
  admin_username      = local.username
  network_interface_ids = [
    azurerm_network_interface.tocode.id
  ]

  admin_ssh_key {
    username   = local.username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

}

provider "cloudflare" {
  email   = var.email
  api_token = var.api_token
}

resource "cloudflare_record" "tocode" {
  zone_id = "4e2e9ede8c5b56eee1b6f3d984ab7ac3"
  name    = local.vm_name
  value   = azurerm_linux_virtual_machine.tocode.public_ip_address
  type    = "A"
  ttl     = 1
  proxied = false
}


output "instance_ip" {
  value = azurerm_linux_virtual_machine.tocode.public_ip_address
}

output "instance_name" {
  value = azurerm_linux_virtual_machine.tocode.name
}

output "username" {
  value = local.username
}

output "email" {
  value = var.email
}
