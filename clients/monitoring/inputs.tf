variable "realm_id" {
  type        = string
  description = "Name of Realm used as identifier"
}

variable "domain" {
  type        = string
  description = "Domain used to build the application urls.  Do not specify the application subdomain.  Example for https://argocd.env.domain.com supply env.domain.com"
}

variable "admin_group_id" {
  description = "Admin group ID where admin role would be mapped"
  type    = string
  default = null
}

variable "users_group_id" {
  description = "User group ID where editor role would be mapped"
  type    = string
  default = null
}