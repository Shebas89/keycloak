variable "client_prefix" {
  type        = string
  default     = ""
  description = "environment id prefix so we don't collide with clients in a shared instance"
}

variable "client_secret" {
  type        = string
  default     = ""
  description = "Provide value here if desired, if left empty KeyCloak will generate a secret."
}