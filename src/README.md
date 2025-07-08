---
tags:
  - component/tgw/routes
  - layer/network
  - provider/aws
---

# Component: `tgw/routes`

This component is responsible for managing Transit Gateway route tables, including static routes and route propagation. It enables controlled routing between VPC attachments in a Transit Gateway network.

## Usage

**Stack Level**: Regional

This component is typically deployed in the network account where the Transit Gateway exists. It manages both static routes and route propagation for Transit Gateway route tables.

### Basic Example

Here's a simple example using physical IDs:

```yaml
components:
  terraform:
    tgw/routes:
      vars:
        transit_gateway_route_table_id: "tgw-rtb-0123456789abcdef0"

        # Static routes for specific CIDR blocks
        static_routes:
          - cidr_block: "10.100.0.0/16"
            attachment_id: "tgw-attach-0123456789abcdef0"

        # Route propagation from VPC attachments
        propagated_routes:
          - attachment_id: "tgw-attach-0123456789abcdef1"
            vpc_id: "vpc-0123456789abcdef0"
```

The same configuration using terraform outputs:

```yaml
components:
  terraform:
    tgw/routes:
      vars:
        transit_gateway_route_table_id: !terraform.output tgw/hub transit_gateway_route_table_id

        # Static routes for specific CIDR blocks
        static_routes:
          - cidr_block: !terraform.output vpc edge-vpc vpc_cidr
            attachment_id: !terraform.output tgw/attachment edge-vpc transit_gateway_attachment_id

        # Route propagation from VPC attachments
        propagated_routes:
          - attachment_id: !terraform.output tgw/attachment app-vpc transit_gateway_attachment_id
            vpc_id: !terraform.output vpc app-vpc vpc_id
```

### Multiple Environment Example

For environments with multiple routing requirements, here's an example using physical IDs:

```yaml
components:
  terraform:
    tgw/routes/nonprod:
      metadata:
        component: tgw/routes
      vars:
        transit_gateway_route_table_id: "tgw-rtb-0123456789abcdef1"

        # Static routes for specific destinations
        static_routes:
          - cidr_block: "10.20.0.0/16"
            attachment_id: "tgw-attach-0123456789abcdef2"
          - cidr_block: "10.30.0.0/16"
            attachment_id: "tgw-attach-0123456789abcdef3"

        # Enable route propagation from specific VPCs
        propagated_routes:
          - attachment_id: "tgw-attach-0123456789abcdef4"
            vpc_id: "vpc-0123456789abcdef1"
          - attachment_id: "tgw-attach-0123456789abcdef5"
            vpc_id: "vpc-0123456789abcdef2"
```

The same configuration using terraform outputs:

```yaml
components:
  terraform:
    tgw/routes/nonprod:
      metadata:
        component: tgw/routes
      vars:
        transit_gateway_route_table_id: !terraform.output tgw/hub transit-use1-nonprod transit_gateway_route_table_id

        # Static routes for specific destinations
        static_routes:
          - cidr_block: !terraform.output vpc dev-use1-edge vpc_cidr
            attachment_id: !terraform.output tgw/attachment dev-use1-edge transit_gateway_attachment_id
          - cidr_block: !terraform.output vpc staging-use1-edge vpc_cidr
            attachment_id: !terraform.output tgw/attachment staging-use1-edge transit_gateway_attachment_id

        # Enable route propagation from specific VPCs
        propagated_routes:
          - attachment_id: !terraform.output tgw/attachment dev-use1-network transit_gateway_attachment_id
            vpc_id: !terraform.output vpc dev-use1-network vpc_id
          - attachment_id: !terraform.output tgw/attachment staging-use1-network transit_gateway_attachment_id
            vpc_id: !terraform.output vpc staging-use1-network vpc_id
```

## Important Notes

1. **Static Routes vs Propagated Routes**:
   - Use static routes for specific CIDR destinations
   - Use route propagation for dynamic routing from attached VPCs
   - Blackhole routes can be created to drop traffic to specific CIDRs

2. **Route Table Management**:
   - Each Transit Gateway can have multiple route tables
   - Route tables can be associated with specific VPC attachments
   - Route propagation enables automatic route sharing

3. **Best Practices**:
   - Keep prod and nonprod routing separate
   - Document route purposes and dependencies
   - Use clear naming conventions for route tables
   - Consider using blackhole routes for security

<!-- prettier-ignore-start -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- prettier-ignore-end -->
