variable "region" {
  type        = string
  description = "AWS Region"
}

variable "static_routes" {
  type = list(object({
    cidr_block    = string
    attachment_id = string
    blackhole     = optional(bool, false)
  }))
  description = "List of static route configurations for the Transit Gateway route table"
  default     = []

  # Validates that each route has exactly one of:
  # 1. A non-empty attachment_id with blackhole=false
  # 2. An empty attachment_id with blackhole=true
  validation {
    condition = alltrue([
      for route in var.static_routes :
      (route.attachment_id != "" && route.blackhole == false) ||
      (route.attachment_id == "" && route.blackhole == true)
    ])
    error_message = join("\n", [
      for route in var.static_routes :
      !((route.attachment_id != "" && route.blackhole == false) || (route.attachment_id == "" && route.blackhole == true)) ?
      "Invalid route configuration found for CIDR ${route.cidr_block}: attachment_id='${route.attachment_id}', blackhole=${route.blackhole}. Must have either attachment_id OR blackhole=true, but not both." : ""
      if !((route.attachment_id != "" && route.blackhole == false) || (route.attachment_id == "" && route.blackhole == true))
    ])
  }
}

variable "propagated_routes" {
  type = list(object({
    attachment_id = string
    vpc_id        = optional(string, "")
  }))
  description = "List of Transit Gateway attachments to propagate routes from for the given Transit Gateway route table"
  default     = []
}

variable "transit_gateway_route_table_id" {
  type        = string
  description = "ID of the Transit Gateway route table"
}
