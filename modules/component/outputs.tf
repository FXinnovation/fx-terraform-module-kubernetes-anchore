output "deployment" {
  value = kubernetes_deployment.this
}

output "service" {
  value = kubernetes_service.this
}

output "config_map" {
  value = element(concat(kubernetes_config_map.this.*, lsit({})), 0)
}
