variable "domain" {
  default = "local"
  type    = string
}

variable "groups" {
  description = "Name of the groups"
  default     = ["Administrator", "Users"]
  type        = set(string)
}