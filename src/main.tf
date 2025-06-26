locals {
  enabled = module.this.enabled

  /* Flatten the list of route_propagations if route.propagated is true, else it does not
   get added to the list and if not added to the list it will not get propagated to the tgw rt.
   Lastly if nothing has route.propagated then the list obviously defaults to an empty array.*/
  route_propagations = local.enabled ? flatten([
    for rt in var.transit_gateway_route_tables : [
      for route in rt.routes : {
        route_table_id = rt.transit_gateway_route_table_id
        attachment_id  = route.attachment_id
        propagated     = route.propagated
      } if route.propagated
    ]
  ]) : []


  /* Flatten the list of route_associations if route.associated is true, else it does not
   get added to the list and if not added to the list it will not get associated to the tgw rt.
   Lastly if nothing has route.associated then the list obviously defaults to an empty array.*/
  route_associations = local.enabled ? flatten([
    for rt in var.transit_gateway_route_tables : [
      for route in rt.routes : {
        route_table_id = rt.transit_gateway_route_table_id
        attachment_id  = route.attachment_id
        associated     = route.associated
      } if route.associated
    ]
  ]) : []

  /* Flatten the list of static routes if they are present.  This var is marked as optional in the variables
 file so if its empty, it defaults to an empty array.*/
  static_routes = local.enabled ? flatten([
    for rt in var.transit_gateway_route_tables : [
      for route in rt.static_routes : {
        route_table_id = rt.transit_gateway_route_table_id
        cidr_block     = route.cidr_block
        attachment_id  = route.attachment_id
        blackhole      = route.blackhole
      }
    ]
  ]) : []
}

# Iterate over the route_propagations and attaches an attachment_id > tgw route table.
resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  for_each = {
    for route in local.route_propagations : "${route.route_table_id}:${route.attachment_id}" => route
  }

  transit_gateway_attachment_id  = each.value.attachment_id
  transit_gateway_route_table_id = each.value.route_table_id
}

# Iterate over the route_associations and associates an attachment_id > tgw route table.
resource "aws_ec2_transit_gateway_route_table_association" "this" {
  for_each = {
    for route in local.route_associations : "${route.route_table_id}:${route.attachment_id}" => route
  }

  transit_gateway_attachment_id  = each.value.attachment_id
  transit_gateway_route_table_id = each.value.route_table_id
}

# Handle static routes
resource "aws_ec2_transit_gateway_route" "this" {
  for_each = {
    for route in local.static_routes : "${route.route_table_id}:${route.cidr_block}" => route
  }

  transit_gateway_route_table_id = each.value.route_table_id
  destination_cidr_block         = each.value.cidr_block
  transit_gateway_attachment_id  = each.value.attachment_id
  blackhole                      = each.value.blackhole
}
