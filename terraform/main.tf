data "azurerm_client_config" "current" {}

# -------------------------
# Virtual Network
# -------------------------

resource "azurerm_virtual_network" "main" {
  name                = "wordpress-learning-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# -------------------------
# AKS Subnet
# -------------------------

resource "azurerm_subnet" "aks_subnet" {
  name                 = "wordpress-learning-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# -------------------------
# DB Subnet
# -------------------------

resource "azurerm_subnet" "db_subnet" {
  name                 = "wordpress-learning-db-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]

  delegation {
    name = "mysql-delegation"

    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

# # -------------------------
# # NSG
# # -------------------------

# resource "azurerm_network_security_group" "aks_nsg" {
#   name                = "wordpress-learning-aks-nsg"
#   location            = var.location
#   resource_group_name = var.resource_group_name
# }

# resource "azurerm_network_security_rule" "https" {
#   name                        = "AllowHTTPS"
#   priority                    = 100
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "443"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"

#   resource_group_name         = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.aks_nsg.name
# }

# resource "azurerm_subnet_network_security_group_association" "aks_associate" {
#   subnet_id                 = azurerm_subnet.aks_subnet.id
#   network_security_group_id = azurerm_network_security_group.aks_nsg.id
# }

# # -------------------------
# # ACR
# # -------------------------

# resource "azurerm_container_registry" "acr" {
#   name                = "wordpresslearningacr123"
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   sku                 = "Basic"
#   admin_enabled       = false
# }

# # -------------------------
# # Key Vault
# # -------------------------

# resource "azurerm_key_vault" "main" {
#   name                = "wordpresslearningkv123"
#   location            = var.location
#   resource_group_name = var.resource_group_name

#   tenant_id = data.azurerm_client_config.current.tenant_id

#   sku_name = "standard"

#   purge_protection_enabled = true
# }

# # -------------------------
# # AKS
# # -------------------------

# resource "azurerm_kubernetes_cluster" "aks" {
#   name                = var.aks_cluster_name
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   dns_prefix          = var.dns_prefix

#   private_cluster_enabled = true
#     oidc_issuer_enabled = true

#   default_node_pool {
#     name           = "default"
#     node_count     = var.node_count
#     vm_size        = var.vm_size
#     vnet_subnet_id = azurerm_subnet.aks_subnet.id
#   }

#   identity {
#     type = "SystemAssigned"
#   }

# network_profile {
#   network_plugin = "azure"
#   network_policy = "azure"

#   service_cidr       = "10.240.0.0/16"
#   dns_service_ip     = "10.240.0.10"
# #   docker_bridge_cidr = "172.17.0.1/16"
# }
# }

# # -------------------------
# # AKS -> ACR Pull Access
# # -------------------------

# resource "azurerm_role_assignment" "aks_acr_pull" {
#   principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
#   role_definition_name = "AcrPull"
#   scope                = azurerm_container_registry.acr.id
# }