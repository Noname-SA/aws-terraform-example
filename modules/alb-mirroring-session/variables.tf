variable "vxlanid" {
  type        = number
  default     = 131073
  description = "VXLAN id for mirroring session. Noname platform uses this to determine source. Default represents aws-mirroring-1. Add +1 to increase index"
}

variable "tmt_id" {
  type        = string
  description = "Existing traffic mirroring target ID"
}

variable "tmf_id" {
  type        = string
  description = "Existing traffic mirroring filter ID"
}

variable "alb_arn" {
  type        = string
  description = "ARN of ALB that will be mirrored"
}

variable "prefix" {
  type        = string
  description = "Prefix to use when tagging and naming sessions"
}
