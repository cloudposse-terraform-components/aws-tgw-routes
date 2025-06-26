variable "region" {
  type        = string
  description = "AWS Region"
}

variable "transit_gateway_route_tables" {
  type = list(object({
    transit_gateway_route_table_id = string
    routes = list(object({
      attachment_id = string
      propagated    = optional(bool, true)
      associated    = optional(bool, true)
    }))
    static_routes = optional(list(object({
      cidr_block    = string
      attachment_id = string
      blackhole     = optional(bool, false)
    })), [])
  }))
  description = "List of Transit Gateway route table configurations"
  default     = []
}
