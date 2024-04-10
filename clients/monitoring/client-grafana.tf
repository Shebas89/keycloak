resource "random_password" "grafanaSecret" {
  count = var.client_secret_grafana == null ? 1 : 0

  length      = 32
  special     = false
  min_lower   = 2
  min_numeric = 2
  min_upper   = 2
}

resource "keycloak_openid_client" "grafana_client" {
  realm_id                     = var.realm_id
  client_id                    = "${var.realm_id}_grafana"
  name                         = "Grafana for ${var.realm_id}"
  enabled                      = true
  access_type                  = "CONFIDENTIAL"
  standard_flow_enabled        = true
  direct_access_grants_enabled = false

  root_url = "https://grafana.${var.domain}"
  base_url = "https://grafana.${var.domain}"

  client_secret = try(var.client_secret_grafana, random_password.grafanaSecret[0].result)

  valid_redirect_uris = [
    "https://grafana.${var.domain}/login/generic_oauth"
  ]

  login_theme = "keycloak"
}

resource "keycloak_openid_client_default_scopes" "grafana_default_scopes" {
  realm_id  = var.realm_id
  client_id = keycloak_openid_client.grafana_client.id

  default_scopes = [
    keycloak_openid_client_scope.client_scope_grafana.name,
  ]
}

resource "keycloak_openid_client_scope" "client_scope_grafana" {
  realm_id               = var.realm_id
  name                   = "Grafana"
  description            = "Client scope for use by Grafana clients"
  include_in_token_scope = true
}

resource "keycloak_openid_user_attribute_protocol_mapper" "profile" {
  realm_id        = var.realm_id
  client_scope_id = keycloak_openid_client_scope.client_scope_grafana.id
  name            = "profile"

  user_attribute = "profile"
  claim_name     = "profile"

  claim_value_type     = "String"
  add_to_id_token      = true
  add_to_access_token  = true
  add_to_userinfo      = true
  multivalued          = false
  aggregate_attributes = false
}

resource "keycloak_openid_user_property_protocol_mapper" "email" {
  realm_id        = var.realm_id
  client_scope_id = keycloak_openid_client_scope.client_scope_grafana.id
  name            = "email"

  user_property = "email"
  claim_name    = "email"

  claim_value_type    = "String"
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true
}

resource "keycloak_openid_user_realm_role_protocol_mapper" "realm_roles" {
  realm_id        = var.realm_id
  client_scope_id = keycloak_openid_client_scope.client_scope_grafana.id
  name            = "realm roles"

  claim_name          = "realm_access.roles"
  multivalued         = true
  claim_value_type    = "String"
  add_to_id_token     = false
  add_to_access_token = true
  add_to_userinfo     = false
}

resource "keycloak_openid_user_client_role_protocol_mapper" "client_roles" {
  realm_id        = var.realm_id
  client_scope_id = keycloak_openid_client_scope.client_scope_grafana.id
  name            = "client roles"

  claim_name          = "resource_access.$${client_id}.roles"
  multivalued         = true
  claim_value_type    = "String"
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = false
}

resource "keycloak_openid_user_property_protocol_mapper" "username" {
  realm_id        = var.realm_id
  client_scope_id = keycloak_openid_client_scope.client_scope_grafana.id
  name            = "username"

  user_property       = "username"
  claim_name          = "preferred_username"
  claim_value_type    = "String"
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true
}

resource "keycloak_openid_group_membership_protocol_mapper" "groups" {
  realm_id        = var.realm_id
  client_scope_id = keycloak_openid_client_scope.client_scope_grafana.id
  name            = "groups"

  claim_name          = "groups"
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true
}

resource "keycloak_role" "admin_client_role" {
  realm_id    = var.realm_id
  client_id = keycloak_openid_client.grafana_client.id
  name        = "admin"
  description = "admin Role"
  attributes = {
    "roleType" = "admin"
  }
}

resource "keycloak_role" "editor_client_role" {
  realm_id    = var.realm_id
  client_id   = keycloak_openid_client.grafana_client.id
  name        = "editor"
  description = "editor Role"
  attributes = {
    "roleType" = "editor"
  }
}

resource "keycloak_group_roles" "admin_group_roles" {
  realm_id = var.realm_id
  group_id = var.admin_group_id

  role_ids = [
    keycloak_role.admin_client_role.id
  ]
}

resource "keycloak_group_roles" "editor_group_roles" {
  realm_id = var.realm_id
  group_id = var.users_group_id

  role_ids = [
    keycloak_role.editor_client_role.id
  ]
}
