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

variable "sonarqube_membership_mapper_type" {
  type        = string
  default     = "group-list"
  description = "Defines the type of membership mapper to use.  Can use either role-list or group-list mappers.  Valid options are role-list or group-list"
  validation {
    condition     = contains(["role-list", "group-list", "none"], var.sonarqube_membership_mapper_type)
    error_message = "valid values for var sonarqube_membership_mapper_type are ('role-list' or 'group-list' or 'none')"
  }
}