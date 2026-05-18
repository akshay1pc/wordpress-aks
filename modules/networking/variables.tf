variable "location" {}

variable "resource_group_name" {}

variable "vnet_name" {}

variable "address_space" {
  type = list(string)
}

variable "aks_subnet_name" {}

variable "aks_subnet_prefix" {
  type = list(string)
}

variable "db_subnet_name" {}

variable "db_subnet_prefix" {
  type = list(string)
}