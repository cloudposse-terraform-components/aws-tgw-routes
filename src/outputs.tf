output "transit_gateway_route_table_propagations" {
  value       = aws_ec2_transit_gateway_route_table_propagation.this
  description = "TGW route table propagations"
}

output "transit_gateway_route_table_associations" {
  value       = aws_ec2_transit_gateway_route_table_association.this
  description = "TGW route table associations"
}

output "transit_gateway_static_routes" {
  value       = aws_ec2_transit_gateway_route.this
  description = "TGW static routes"
}
