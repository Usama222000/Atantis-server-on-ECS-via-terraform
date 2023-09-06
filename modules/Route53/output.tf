output "ROUTE53_ZONE_ARN" {
  value = toset([
    for rout in aws_route53_zone.this : rout.arn
  ])
}

output "ROUTE53_ZONE_ID" {
  value       = aws_route53_zone.this[*].zone_id
}

output "ROUTE53_ZONE_NAME_SERVERS" {
  value       = aws_route53_zone.this[*].name_servers
}

output "ROUTE53_RECORD_NAME" {
  value = toset([
    for record in aws_route53_record.this : record.name
  ])
}