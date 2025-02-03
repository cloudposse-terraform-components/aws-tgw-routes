locals {
  enabled = module.this.enabled
}

# Allow traffic from the Transit Gateway to the VPC attachments
# Propagations will create propagated routes
resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  for_each = local.enabled ? {
    for route in var.propagated_routes : route.attachment_id => route
  } : {}

  transit_gateway_attachment_id  = each.value.attachment_id
  transit_gateway_route_table_id = var.transit_gateway_route_table_id
}

resource "aws_ec2_transit_gateway_route" "this" {
  for_each = local.enabled ? {
    for route in var.static_routes : route.cidr_block => route
  } : {}

  transit_gateway_route_table_id = var.transit_gateway_route_table_id
  destination_cidr_block         = each.value.cidr_block
  transit_gateway_attachment_id  = each.value.attachment_id
  blackhole                      = each.value.blackhole
}
