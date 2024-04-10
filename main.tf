module "Realm" {
  source = "./realm"

  realmId      = "realm-test"
  display_name = "Realm Test"
}

module "groups" {
  source   = "./groups"
  for_each = var.groups

  realm_id   = module.Realm.realm_id
  group_name = each.value
}

module "clientArgoCD" {
  source = "./clients/argocd"

  realm_id = module.Realm.realm_id
  domain   = var.domain
}

module "clientGitlab" {
  source = "./clients/gitlab"

  realm_id = module.Realm.realm_id
  domain   = var.domain
}

module "clientKiali" {
  source = "./clients/kiali"

  realm_id = module.Realm.realm_id
  domain   = var.domain
}

module "clientMattermost" {
  source = "./clients/mattermost"

  realm_id = module.Realm.realm_id
  domain   = var.domain
}

module "clientMonitoring" {
  source = "./clients/monitoring"

  realm_id = module.Realm.realm_id
  domain   = var.domain
  admin_group_id = module.groups["Administrator"].id
  users_group_id = module.groups["Users"].id
}

module "clientNexus" {
  source = "./clients/nexus"

  realm_id = module.Realm.realm_id
  domain   = var.domain
}

module "clientNeuvector" {
  source = "./clients/neuvector"

  realm_id = module.Realm.realm_id
  domain   = var.domain
}

module "clientSonarqube" {
  source = "./clients/sonarqube"

  realm_id = module.Realm.realm_id
  domain   = var.domain
}
