resource "keycloak_saml_client" "nexus_client" {
  realm_id                  = var.realm_id
  client_id                 = "https://nexus.${var.domain}/service/rest/v1/security/saml/metadata"
  name                      = "Nexus for ${var.realm_id}"
  enabled                   = true
  client_signature_required = true
  encrypt_assertions        = true
  valid_redirect_uris = [
    "https://nexus.${var.domain}/saml"
  ]

  #Are these optional???
  #sign_documents          = false
  #sign_assertions         = true
  #include_authn_statement = true

  #signing_certificate = file("saml-cert.pem")
  #signing_private_key = file("saml-key.pem")
}

resource "keycloak_saml_client_default_scopes" "client_default_scopes" {
  realm_id  = var.realm_id
  client_id = keycloak_saml_client.nexus_client.id

  default_scopes = ["role_list"]
}


resource "keycloak_saml_user_property_protocol_mapper" "firstname" {
  realm_id  = var.realm_id
  client_id = keycloak_saml_client.nexus_client.id

  name                       = "First Name"
  user_property              = "firstName"
  saml_attribute_name        = "firstName"
  friendly_name              = "firstName"
  saml_attribute_name_format = "Basic"
}

resource "keycloak_saml_user_property_protocol_mapper" "username" {
  depends_on = [keycloak_saml_client.nexus_client]
  realm_id   = var.realm_id
  client_id  = keycloak_saml_client.nexus_client.id
  
  name                       = "username"
  user_property              = "username"
  saml_attribute_name        = "username"
  friendly_name              = "username"
  saml_attribute_name_format = "Basic"
}

resource "keycloak_saml_user_property_protocol_mapper" "email" {
  realm_id  = var.realm_id
  client_id = keycloak_saml_client.nexus_client.id

  name                       = "Email"
  user_property              = "email"
  saml_attribute_name        = "email"
  friendly_name              = "email"
  saml_attribute_name_format = "Basic"
}

resource "keycloak_saml_user_property_protocol_mapper" "lastname" {
  realm_id  = var.realm_id
  client_id = keycloak_saml_client.nexus_client.id

  name                       = "Last Name"
  user_property              = "lastName"
  saml_attribute_name        = "lastName"
  friendly_name              = "elastNamemail"
  saml_attribute_name_format = "Basic"
}

resource "keycloak_generic_protocol_mapper" "groups_mapper" {
  count           = var.sonarqube_membership_mapper_type == "group-list" ? 1 : 0
  realm_id        = var.realm_id
  client_id       = keycloak_saml_client.nexus_client.id
  name            = "Groups"
  protocol        = "saml"
  protocol_mapper = "saml-group-membership-mapper"
  config = {
    "single"               = "true"
    "attribute.nameformat" = "basic"
    "full.path"            = "false"
    "friendly.name"        = "Groups"
    "attribute.name"       = "groups"
  }
}
