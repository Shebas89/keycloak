resource "random_password" "prometheusSecret" {
  count = var.client_secret_prometheus == null ? 1 : 0

  length      = 32
  special     = false
  min_lower   = 2
  min_numeric = 2
  min_upper   = 2
}

resource "keycloak_openid_client" "prometheus_client" {
  realm_id                     = var.realm_id
  client_id                    = "${var.realm_id}_prometheus"
  name                         = "Prometheus for ${var.realm_id}"
  enabled                      = true
  access_type                  = "CONFIDENTIAL"
  standard_flow_enabled        = true
  direct_access_grants_enabled = false

  root_url = "https://prometheus.${var.domain}"
  base_url = "https://prometheus.${var.domain}"

  client_secret = try(var.client_secret_prometheus, random_password.prometheusSecret[0].result)

  valid_redirect_uris = [
    "https://prometheus.${var.domain}/login/generic_oauth"
  ]

  login_theme = "keycloak"
}
