output "client_id" {
  value       = keycloak_openid_client.gitlab_client.client_id
  sensitive   = false
  description = "OIDC client ID"
}

output "client_secret" {
  value       = keycloak_openid_client.gitlab_client.client_secret
  sensitive   = true
  description = "OIDC client secret"
}
