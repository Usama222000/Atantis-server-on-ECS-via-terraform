variable "TAGS" {
  default = {}
}
variable "COMMON_TAGS" {
  default = {}
}
variable "HOSTED_ZONE_ID" {
  type = string
  default = ""
}
variable "CREATE_ZONE" {
  default = false
  type    = bool
}
variable "CREATE_RECORD" {
  type        = bool
  default     = false
}
variable "ZONE_NAME" {
  description = "Name of DNS zone"
  type        = string
  default     = null
}
variable "RECORDS" {
  description = "List of maps of DNS records"
  type        = any
  default     = []
}

variable "DESCRIPTION" {
  default = ""
}
variable "FORCE_DESTROY" {
  default = true
}
variable "VPCS" {
  default = []
}
