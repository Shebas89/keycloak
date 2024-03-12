output "client_id_alert_manager" {
  value       = keycloak_openid_client.alert_manager_client.client_id
  sensitive   = false
  description = "OIDC client ID"
}

output "client_secret_alertmanager" {
  value       = keycloak_openid_client.alert_manager_client.client_secret
  sensitive   = true
  description = "OIDC client secret"
}

output "client_id_grafana" {
  value       = keycloak_openid_client.grafana_client.client_id
  sensitive   = false
  description = "OIDC client ID"
}

output "client_secret_grafana" {
  value       = keycloak_openid_client.grafana_client.client_secret
  sensitive   = true
  description = "OIDC client secret"
}

output "client_id_prometheus" {
  value       = keycloak_openid_client.prometheus_client.client_id
  sensitive   = false
  description = "OIDC client ID"
}

output "client_secret_prometheus" {
  value       = keycloak_openid_client.prometheus_client.client_secret
  sensitive   = true
  description = "OIDC client secret"
}
