# resource "azurerm_resource_group" "rg" {
#   name     = var.resource_group_name
#   location = var.location
# }

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

module "networking" {
  source = "../../modules/networking"

  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  vnet_name      = "wordpress-learning-vnet"
  address_space  = ["10.0.0.0/16"]

  aks_subnet_name   = "wordpress-learning-subnet"
  aks_subnet_prefix = ["10.0.1.0/24"]

  db_subnet_name   = "wordpress-learning-db-subnet"
  db_subnet_prefix = ["10.0.2.0/24"]
}

module "acr" {
  source = "../../modules/acr"

  acr_name           = "wordpresslearningacr123"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

module "nsg" {
  source = "../../modules/nsg"

  nsg_name           = "wordpress-learning-aks-nsg"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  subnet_id = module.networking.aks_subnet_id
}

module "keyvault" {
  source = "../../modules/keyvault"

  keyvault_name      = "wordpresslearningkv123"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

module "aks" {
  source = "../../modules/aks"

  cluster_name       = var.aks_cluster_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  dns_prefix = var.dns_prefix
  node_count = var.node_count
  vm_size    = var.vm_size

  subnet_id = module.networking.aks_subnet_id
  acr_id    = module.acr.acr_id
}