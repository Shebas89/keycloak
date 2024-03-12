resource "random_password" "client_secret" {
  count = var.client_secret == null ? 1 : 0

  length      = 32
  special     = false
  min_lower   = 2
  min_numeric = 2
  min_upper   = 2
}

resource "keycloak_openid_client" "client" {
  realm_id                     = var.realm_id
  client_id                    = "${var.realm_id}_${var.client}"
  name                         = "${var.client} for ${var.realm_id}"
  enabled                      = true
  access_type                  = "CONFIDENTIAL"
  standard_flow_enabled        = true
  direct_access_grants_enabled = false

  root_url = var.root_url
  base_url = var.base_url

  client_secret       = try(var.client_secret, random_password.client_secret[0].result)
  valid_redirect_uris = var.valid_redirect_uris

  login_theme = "keycloak"
}

resource "keycloak_openid_client_default_scopes" "client_default_scopes" {
  count = var.create_scope == true ? 1 : 0 
  
  realm_id  = var.realm_id
  client_id = keycloak_openid_client.client.id

  default_scopes = [
    keycloak_openid_client_scope.client_scope[0].name
  ]
}

resource "keycloak_openid_client_scope" "client_scope" {
  count = var.create_scope == true ? 1 : 0 

  realm_id               = var.realm_id
  name                   = "${var.client}"
  description            = "Client scope for use by ${var.client} clients"
  include_in_token_scope = true
}

resource "keycloak_openid_user_attribute_protocol_mapper" "user_attribute_protocol_mapper" {
  for_each = {
    for user_attribute_protocol in var.user_attribute_protocols : user_attribute_protocol.name => user_attribute_protocol
  }

  realm_id             = var.realm_id
  client_scope_id      = keycloak_openid_client_scope.client_scope[0].id
  name                 = each.value.name
  user_attribute       = each.value.user_attribute
  claim_name           = each.value.claim_name
  claim_value_type     = each.value.claim_value_type
  add_to_id_token      = each.value.add_to_id_token
  add_to_access_token  = each.value.add_to_access_token
  add_to_userinfo      = each.value.add_to_userinfo
  multivalued          = each.value.multivalued
  aggregate_attributes = each.value.aggregate_attributes
}

resource "keycloak_openid_user_property_protocol_mapper" "user_property_protocol_mapper" {
  for_each = {
    for user_property_protocol in var.user_property_protocols : user_property_protocol.name => user_property_protocol
  }

  realm_id            = var.realm_id
  client_scope_id     = keycloak_openid_client_scope.client_scope[0].id
  name                = each.value.name
  user_property       = each.value.user_property
  claim_name          = each.value.claim_name
  claim_value_type    = each.value.claim_value_type
  add_to_id_token     = each.value.add_to_id_token
  add_to_access_token = each.value.add_to_access_token
  add_to_userinfo     = each.value.add_to_userinfo
}

resource "keycloak_openid_full_name_protocol_mapper" "full_name_protocol_mapper" {
  for_each = {
    for full_name_mapper in var.full_name_mappers : full_name_mapper.name => full_name_mapper
  }
  
  realm_id            = var.realm_id
  client_scope_id     = keycloak_openid_client_scope.client_scope[0].id
  name                = each.value.name
  add_to_id_token     = each.value.add_to_id_token
  add_to_access_token = each.value.add_to_access_token
  add_to_userinfo     = each.value.add_to_userinfo
}

resource "keycloak_openid_group_membership_protocol_mapper" "group_membership_protocol_mapper" {
  for_each = {
    for group_membership_protocol in var.group_membership_protocols : group_membership_protocol.name => group_membership_protocol
  }

  realm_id            = var.realm_id
  client_scope_id     = keycloak_openid_client_scope.client_scope[0].id
  name                = each.value.name
  claim_name          = each.value.claim_name
  add_to_id_token     = each.value.add_to_id_token
  add_to_access_token = each.value.add_to_access_token
  add_to_userinfo     = each.value.add_to_userinfo
}
