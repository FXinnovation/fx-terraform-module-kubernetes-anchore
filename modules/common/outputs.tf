output "configuration_config_map" {
  value = kubernetes_config_map.configuration
}

output "environment_config_map" {
  value = kubernetes_config_map.environment
}

output "environment_secret" {
  value = kubernetes_secret.environment
}
