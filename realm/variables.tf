variable display_name {
  default     = "Test Realm"
  description = "value"
  type        = string
}

variable realmId {
  default     = "realm-test"
  description = "value"
  type        = string
}

variable password_policy {
  default     = "hashAlgorithm(pbkdf2-sha256) and forceExpiredPasswordChange(90) and specialChars(2) and passwordHistory(5) and length(12) and notUsername(undefined)"
  description = "value"
  type        = string
}
