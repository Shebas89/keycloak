resource "keycloak_group" "group" {
  realm_id = var.realm_id
  name     = var.group_name
}
