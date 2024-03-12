resource "random_password" "kialiSecret" {
  count = var.client_secret_alertmanager == null ? 1 : 0

  length      = 32
  special     = false
  min_lower   = 2
  min_numeric = 2
  min_upper   = 2
}

resource "keycloak_openid_client" "alert_manager_client" {
  realm_id                     = var.realm_id
  client_id                    = "${var.realm_id}_alertmanager"
  name                         = "Alert Manager for ${var.realm_id}"
  enabled                      = true
  access_type                  = "CONFIDENTIAL"
  standard_flow_enabled        = true
  direct_access_grants_enabled = false

  root_url = "https://alertmanager.${var.domain}"
  base_url = "https://alertmanager.${var.domain}"

  client_secret = try(var.client_secret_alertmanager, random_password.kialiSecret[0].result)

  valid_redirect_uris = [
    "https://alertmanager.${var.domain}/login/generic_oauth"
  ]

  login_theme = "keycloak"
}
