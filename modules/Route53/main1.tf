locals {
  # convert from list to map with unique keys
  recordsets = { for rs in var.RECORDS : join(" ", compact(["${rs.name} ${rs.type}", lookup(rs, "set_identifier", "")])) => rs }
}

resource "aws_route53_zone" "this" {
  count = var.CREATE_ZONE ? 1 : 0
  name          = var.ZONE_NAME
  comment       = var.DESCRIPTION != "" ? var.DESCRIPTION : null
  force_destroy = var.FORCE_DESTROY
  tags = merge(
    var.COMMON_TAGS,
    var.TAGS,
  )
  dynamic "vpc" {
    for_each = var.VPCS
    content {
      vpc_id     = vpc.value.vpc_id
      vpc_region = lookup(vpc.value, "vpc_region", null)
    }
  }
}


resource "aws_route53_record" "this" {
  for_each = var.CREATE_RECORD ? local.recordsets : tomap({})

  zone_id        = var.CREATE_ZONE ? aws_route53_zone.this[0].zone_id : var.HOSTED_ZONE_ID
  name           = var.CREATE_ZONE ? "${each.value.name}.${aws_route53_zone.this[0].name}" : each.value.name
  type           = each.value.type
  ttl            = lookup(each.value, "ttl", null)
  records        = lookup(each.value, "records", null)
  set_identifier = lookup(each.value, "set_identifier", null)

  dynamic "alias" {
    /* for_each = each.value.alias.name == null || each.value.alias.name == "" ? {} : each.value.alias */

    for_each = each.value.alias == null || each.value.alias == {}  ? {} : each.value.alias
    content {
      name                   = each.value.alias.name
      zone_id                = each.value.alias.zone_id
      evaluate_target_health = lookup(each.value.alias, "evaluate_target_health", false)
    }
  }

  dynamic "weighted_routing_policy" {

for_each = each.value.weighted_routing_policy == null || each.value.weighted_routing_policy ==  {}   ? [] : [true]
    content {
      weight = each.value.weighted_routing_policy.weight
    }
  }

  dynamic "failover_routing_policy" {

    for_each = each.value.failover_routing_policy == null || each.value.failover_routing_policy ==  {}   ? [] : [true]

    content {
      type = each.value.failover_routing_policy.type
    }
  }

  dynamic "latency_routing_policy" {
    for_each = each.value.latency_routing_policy == null || each.value.latency_routing_policy ==  {}   ? [] : [true]

    content {
      region = each.value.latency_routing_policy.region
    }
  }

  dynamic "geolocation_routing_policy" {
        for_each = each.value.geolocation_routing_policy == null || each.value.geolocation_routing_policy ==  {} ? [] : [true]

    content {
      continent   = each.value.geolocation_routing_policy.continent
    }
  }


}
