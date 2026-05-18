output "aks_cluster_id" {
  value = module.aks.aks_id
}

output "acr_login_server" {
  value = module.acr.acr_login_server
}