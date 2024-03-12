resource "random_password" "argocdSecret" {
  count = var.client_secret == null ? 1 : 0

  length      = 32
  special     = false
  min_lower   = 2
  min_numeric = 2
  min_upper   = 2
}

resource "keycloak_openid_client" "argocd_client" {
  realm_id                     = var.realm_id
  client_id                    = "${var.realm_id}_argocd"
  name                         = "ArgoCD for ${var.realm_id}"
  enabled                      = true
  access_type                  = "CONFIDENTIAL"
  standard_flow_enabled        = true
  direct_access_grants_enabled = false

  root_url = "https://argocd.${var.domain}"
  base_url = "/applications"

  client_secret       = try(var.client_secret, random_password.argocdSecret[0].result)
  valid_redirect_uris = [
    "https://argocd.${var.domain}/*",
    "https://argocd.${var.domain}/login/generic_oauth"
  ]

  login_theme = "keycloak"
}

resource "keycloak_openid_client_default_scopes" "client_default_scopes" {
  realm_id  = var.realm_id
  client_id = keycloak_openid_client.argocd_client.id

  default_scopes = [
    keycloak_openid_client_scope.client_scope.name
  ]
}

resource "keycloak_openid_client_scope" "client_scope" {
  realm_id               = var.realm_id
  name                   = "ArgoCD"
  description            = "Client scope for use by ArgoCD clients"
  include_in_token_scope = true
}

resource "keycloak_openid_user_attribute_protocol_mapper" "profile" {
  realm_id             = var.realm_id
  client_scope_id      = keycloak_openid_client_scope.client_scope.id
  name                 = "profile"
  user_attribute       = "profile"
  claim_name           = "profile"
  claim_value_type     = "String"
  add_to_id_token      = true
  add_to_access_token  = true
  add_to_userinfo      = true
  multivalued          = false
  aggregate_attributes = false
}

resource "keycloak_openid_user_property_protocol_mapper" "email" {
  realm_id            = var.realm_id
  client_scope_id     = keycloak_openid_client_scope.client_scope.id
  name                = "email"
  user_property       = "email"
  claim_name          = "email"
  claim_value_type    = "String"
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true
}

resource "keycloak_openid_user_attribute_protocol_mapper" "nickname" {
  realm_id             = var.realm_id
  client_scope_id      = keycloak_openid_client_scope.client_scope.id
  name                 = "nickname"
  user_attribute       = "nickname"
  claim_name           = "nickname"
  claim_value_type     = "String"
  add_to_id_token      = true
  add_to_access_token  = true
  add_to_userinfo      = true
  multivalued          = false
  aggregate_attributes = false
}

resource "keycloak_openid_full_name_protocol_mapper" "full_name_mapper" {
  realm_id            = var.realm_id
  client_scope_id     = keycloak_openid_client_scope.client_scope.id
  name                = "full-name-mapper"
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true
}

resource "keycloak_openid_group_membership_protocol_mapper" "groups" {
  realm_id            = var.realm_id
  client_scope_id     = keycloak_openid_client_scope.client_scope.id
  name                = "groups"
  claim_name          = "groups"
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true
}

resource "keycloak_openid_user_property_protocol_mapper" "username" {
  realm_id            = var.realm_id
  client_scope_id     = keycloak_openid_client_scope.client_scope.id
  name                = "username"
  user_property       = "username"
  claim_name          = "preferred_username"
  claim_value_type    = "String"
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true
}
