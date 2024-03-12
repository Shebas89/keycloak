variable "client_secret_alertmanager" {
  type        = string
  default     = ""
  description = "Provide value here if desired, if left empty KeyCloak will generate a secret."
}

variable "client_secret_prometheus" {
  type        = string
  default     = ""
  description = "Provide value here if desired, if left empty KeyCloak will generate a secret."
}

variable "client_secret_grafana" {
  type        = string
  default     = ""
  description = "Provide value here if desired, if left empty KeyCloak will generate a secret."
}
