variable "name" {
  description = "Common name, a unique identifier"
  type        = string
}

variable "vpc_cidr" {
  description = "IP range in CIDR notation"
  type        = string
  default     = "10.0.0.0/16"
}

variable "ipv6_enabled" {
  description = "Whether or not IPv6 should be enabled"
  type        = bool
  default     = true
}

variable "vpc_flow_log_enabled" {
  description = "Whether ot not VPC flow log should be enabled. NOTE: additional charges apply"
  type        = bool
  default     = false
}

variable "subnets" {
  description = "A list of subnet declarations"
  type = list(object(
    {
      name        = string
      ig_attached = bool
      tags        = map(string)
    }
  ))
  default = [
    {
      name        = "public"
      ig_attached = true
      tags        = {}
    },
    {
      name        = "private"
      ig_attached = false
      tags        = {}
    }
  ]
}

variable "newbits" {
  description = "How much VPC prefix must be shrunk for subnet allocation"
  type        = number
  default     = 8
}

variable "extra_tags" {
  description = "Map of additional tags to add to module's resources"
  type        = map(string)
  default     = {}
}
