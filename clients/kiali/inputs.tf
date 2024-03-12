variable "realm_id" {
  type        = string
  description = "Name of Realm used as identifier"
}

variable "domain" {
  type        = string
  description = "Domain used to build the application urls.  Do not specify the application subdomain.  Example for https://argocd.env.domain.com supply env.domain.com"
}
