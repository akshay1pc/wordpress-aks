variable "resource_group_name" {
  description = "Azure Resource Group Name"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "aks_cluster_name" {
  description = "AKS Cluster Name"
  type        = string
}

variable "node_count" {
  description = "Default node count"
  type        = number
}

variable "vm_size" {
  description = "VM size for AKS nodes"
  type        = string
}

variable "dns_prefix" {
  description = "DNS Prefix"
  type        = string
}