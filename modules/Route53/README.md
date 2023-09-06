<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_COMMON_TAGS"></a> [COMMON\_TAGS](#input\_COMMON\_TAGS) | n/a | `map` | `{}` | no |
| <a name="input_CREATE_RECORD"></a> [CREATE\_RECORD](#input\_CREATE\_RECORD) | n/a | `bool` | `false` | no |
| <a name="input_CREATE_ZONE"></a> [CREATE\_ZONE](#input\_CREATE\_ZONE) | n/a | `bool` | `false` | no |
| <a name="input_DESCRIPTION"></a> [DESCRIPTION](#input\_DESCRIPTION) | n/a | `string` | `""` | no |
| <a name="input_FORCE_DESTROY"></a> [FORCE\_DESTROY](#input\_FORCE\_DESTROY) | n/a | `bool` | `true` | no |
| <a name="input_RECORDS"></a> [RECORDS](#input\_RECORDS) | List of maps of DNS records | `any` | `[]` | no |
| <a name="input_TAGS"></a> [TAGS](#input\_TAGS) | n/a | `map` | `{}` | no |
| <a name="input_VPCS"></a> [VPCS](#input\_VPCS) | n/a | `list` | `[]` | no |
| <a name="input_ZONE_NAME"></a> [ZONE\_NAME](#input\_ZONE\_NAME) | Name of DNS zone | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ROUTE53_RECORD_NAME"></a> [ROUTE53\_RECORD\_NAME](#output\_ROUTE53\_RECORD\_NAME) | n/a |
| <a name="output_ROUTE53_ZONE_ARN"></a> [ROUTE53\_ZONE\_ARN](#output\_ROUTE53\_ZONE\_ARN) | n/a |
| <a name="output_ROUTE53_ZONE_ID"></a> [ROUTE53\_ZONE\_ID](#output\_ROUTE53\_ZONE\_ID) | n/a |
| <a name="output_ROUTE53_ZONE_NAME_SERVERS"></a> [ROUTE53\_ZONE\_NAME\_SERVERS](#output\_ROUTE53\_ZONE\_NAME\_SERVERS) | n/a |
<!-- END_TF_DOCS -->