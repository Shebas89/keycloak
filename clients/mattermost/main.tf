resource "random_password" "mattermostSecret" {
  count = var.client_secret == null ? 1 : 0

  length      = 32
  special     = false
  min_lower   = 2
  min_numeric = 2
  min_upper   = 2
}

resource "keycloak_openid_client" "mattermost_client" {
  realm_id                     = var.realm_id
  client_id                    = "${var.realm_id}_mattermost"
  name                         = "Mattermost for ${var.realm_id}"
  enabled                      = true
  access_type                  = "CONFIDENTIAL"
  standard_flow_enabled        = true
  direct_access_grants_enabled = false

  root_url = "https://chat.${var.domain}"

  client_secret       = try(var.client_secret, random_password.mattermostSecret[0].result)
  valid_redirect_uris = [
    "https://chat.${var.domain}/login/gitlab/complete",
    "https://chat.${var.domain}/signup/gitlab/complete"
  ]

  login_theme = "keycloak"
}
