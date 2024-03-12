resource "keycloak_saml_client" "sonarqube_client" {
  realm_id                  = var.realm_id
  client_id                 = "${var.realm_id}_sonarqube"
  name                      = "Sonarqube for ${var.realm_id}"
  enabled                   = true
  client_signature_required = false
  valid_redirect_uris = [
    "https://sonarqube.${var.domain}/oauth2/callback/saml"
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
  client_id = keycloak_saml_client.sonarqube_client.id

  default_scopes = [
    "role_list"
  ]
}


resource "keycloak_saml_user_property_protocol_mapper" "login" {
  realm_id                   = var.realm_id
  client_id                  = keycloak_saml_client.sonarqube_client.id
  name                       = "Login"
  user_property              = "Username"
  saml_attribute_name        = "login"
  saml_attribute_name_format = "Unspecified"
}

resource "keycloak_saml_user_property_protocol_mapper" "name" {
  depends_on = [keycloak_saml_client.sonarqube_client]
  realm_id   = var.realm_id
  client_id  = keycloak_saml_client.sonarqube_client.id
  name       = "Name"

  user_property              = "Username"
  saml_attribute_name        = "name"
  saml_attribute_name_format = "Unspecified"
}

resource "keycloak_saml_user_property_protocol_mapper" "email" {
  realm_id  = var.realm_id
  client_id = keycloak_saml_client.sonarqube_client.id
  name      = "Email"

  user_property              = "Email"
  saml_attribute_name        = "email"
  saml_attribute_name_format = "Unspecified"
}

resource "keycloak_generic_protocol_mapper" "groups_mapper" {
  realm_id        = var.realm_id
  client_id       = keycloak_saml_client.sonarqube_client.id
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
