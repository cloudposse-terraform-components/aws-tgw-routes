---
tags:
  - terraform
  - terraform-modules
  - aws
  - components
  - terraform-components
  - root
  - geodesic
  - reference-implementation
  - reference-architecture
---

# Component: `tgw-routes`

Manages AWS Transit Gateway (TGW) route tables, including static routes and
route propagation from VPC attachments. Enables controlled routing between
VPCs connected to a TGW by configuring TGW route table associations,
propagations, and explicit routes as needed.
## Usage

**Stack Level**: Regional

Here's an example snippet for how to use this component.

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
          - attachment_id: "tgw-attach-0123456789abcdef5"
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
          - attachment_id: !terraform.output tgw/attachment staging-use1-network transit_gateway_attachment_id
```


<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.1, < 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.1, < 6.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_roles"></a> [iam\_roles](#module\_iam\_roles) | ../../account-map/modules/iam-roles | n/a |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route_table_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_ec2_transit_gateway_route_table_propagation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_propagation) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br/>This is for some rare cases where resources want additional configuration of tags<br/>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br/>in the order they appear in the list. New attributes are appended to the<br/>end of the list. The elements of the list are joined by the `delimiter`<br/>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br/>See description of individual variables for details.<br/>Leave string and numeric variables as `null` to use default value.<br/>Individual variable settings (non-null) override settings in context object,<br/>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br/>  "additional_tag_map": {},<br/>  "attributes": [],<br/>  "delimiter": null,<br/>  "descriptor_formats": {},<br/>  "enabled": true,<br/>  "environment": null,<br/>  "id_length_limit": null,<br/>  "label_key_case": null,<br/>  "label_order": [],<br/>  "label_value_case": null,<br/>  "labels_as_tags": [<br/>    "unset"<br/>  ],<br/>  "name": null,<br/>  "namespace": null,<br/>  "regex_replace_chars": null,<br/>  "stage": null,<br/>  "tags": {},<br/>  "tenant": null<br/>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br/>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br/>Map of maps. Keys are names of descriptors. Values are maps of the form<br/>`{<br/>   format = string<br/>   labels = list(string)<br/>}`<br/>(Type is `any` so the map values can later be enhanced to provide additional options.)<br/>`format` is a Terraform format string to be passed to the `format()` function.<br/>`labels` is a list of labels, in order, to pass to `format()` function.<br/>Label values will be normalized before being passed to `format()` so they will be<br/>identical to how they appear in `id`.<br/>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br/>Set to `0` for unlimited length.<br/>Set to `null` for keep the existing setting, which defaults to `0`.<br/>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br/>Does not affect keys of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper`.<br/>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br/>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br/>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br/>set as tag values, and output by this module individually.<br/>Does not affect values of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br/>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br/>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br/>Default is to include all labels.<br/>Tags with empty values will not be included in the `tags` output.<br/>Set to `[]` to suppress all generated tags.<br/>**Notes:**<br/>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br/>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br/>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br/>  "default"<br/>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br/>This is the only ID element not also included as a `tag`.<br/>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br/>Characters matching the regex will be removed from the ID elements.<br/>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br/>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
| <a name="input_transit_gateway_route_tables"></a> [transit\_gateway\_route\_tables](#input\_transit\_gateway\_route\_tables) | List of Transit Gateway route table configurations | <pre>list(object({<br/>    transit_gateway_route_table_id = string<br/>    routes = list(object({<br/>      attachment_id = string<br/>      propagated    = optional(bool, true)<br/>      associated    = optional(bool, true)<br/>    }))<br/>    static_routes = optional(list(object({<br/>      cidr_block    = string<br/>      attachment_id = string<br/>      blackhole     = optional(bool, false)<br/>    })), [])<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mock"></a> [mock](#output\_mock) | Mock output example for the Cloud Posse Terraform component template |
<!-- markdownlint-restore -->



## References


- [Cloud Posse Documentation](https://docs.cloudposse.com) - Complete documentation for the Cloud Posse solution

- [Reference Architectures](https://cloudposse.com/) - Launch effortlessly with our turnkey reference architectures, built either by your team or ours.




[<img src="https://cloudposse.com/logo-300x69.svg" height="32" align="right"/>](https://cpco.io/homepage?utm_source=github&utm_medium=readme&utm_campaign=cloudposse-terraform-components/aws-tgw-routes&utm_content=)

