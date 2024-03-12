variable client {
  description = "Name of the client that would be created"
  type = string
}

variable "client_secret" {
  type        = string
  default     = null
  description = "Provide value here if desired, if left empty KeyCloak will generate a secret."
}

variable valid_redirect_uris {
  description = "valid redirect uris for the client"
  type = list(string)
}

variable root_url {
  description = "root url for the client"
  type = string
}

variable base_url {
  description = "base url for the client"
  type = string
}

variable create_scope {
  type = bool
}

variable user_attribute_protocols {
  type = list(object({
    name = string
    user_attribute = string
    claim_name = string
    claim_value_type = string
    add_to_id_token = bool
    add_to_access_token = bool
    add_to_userinfo = bool
    multivalued = bool
    aggregate_attributes = bool
  }))
}

variable user_property_protocols {
  type = list(object({
    name = string
    user_property = string
    claim_name = string
    claim_value_type = string
    add_to_id_token = bool
    add_to_access_token = bool
    add_to_userinfo = bool
  }))
}

variable full_name_mappers {
  type = list(object({
    name = string
    add_to_id_token = bool
    add_to_access_token = bool
    add_to_userinfo = bool
  }))
}

variable group_membership_protocols {
  type = list(object({
    name = string
    claim_name = string
    add_to_id_token = bool
    add_to_access_token = bool
    add_to_userinfo = bool
  }))
}