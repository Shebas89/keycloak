output "client_id" {
  value       = keycloak_saml_client.sonarqube_client.client_id
  sensitive   = false
  description = "OIDC client ID"
}