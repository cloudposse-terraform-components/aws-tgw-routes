output "transit_gateway_route_table_propagations" {
  description = "Transit Gateway route table propagations"
  value       = aws_ec2_transit_gateway_route_table_propagation.this
}

output "transit_gateway_route_table_associations" {
  description = "Transit Gateway route table associations"
  value       = aws_ec2_transit_gateway_route_table_association.this
}

output "transit_gateway_routes" {
  description = "Transit Gateway static routes"
  value       = aws_ec2_transit_gateway_route.this
}
