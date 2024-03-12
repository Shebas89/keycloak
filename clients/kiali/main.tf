resource "random_password" "kialiSecret" {
  count = var.client_secret == null ? 1 : 0

  length      = 32
  special     = false
  min_lower   = 2
  min_numeric = 2
  min_upper   = 2
}

resource "keycloak_openid_client" "kiali_client" {
  realm_id                     = var.realm_id
  client_id                    = "${var.realm_id}_kiali"
  name                         = "Kiali for ${var.realm_id}"
  enabled                      = true
  access_type                  = "CONFIDENTIAL"
  standard_flow_enabled        = true
  direct_access_grants_enabled = false

  root_url = "https://kiali.${var.domain}/kiali"
  base_url = "https://kiali.${var.domain}/kiali"

  client_secret       = try(var.client_secret, random_password.kialiSecret[0].result)
  valid_redirect_uris = [
    "https://kiali.${var.domain}/kiali/*"
  ]

  login_theme = "keycloak"
}
