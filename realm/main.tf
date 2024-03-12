resource "keycloak_realm" "realm" {
  realm                       = var.realmId
  enabled                     = true
  display_name                = var.display_name
  user_managed_access         = true
  ssl_required                = "external"
  default_signature_algorithm = "RS256"
  password_policy             = var.password_policy
}
