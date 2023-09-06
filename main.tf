###################### LOCLAS ##############################
locals {
  # changing the target group arn inside service varible for ECS
   updated_load_balancer = [
    {
      target_group_arn = "${module.ALB.ALB_TARGET_GROUPS_ARN[0]}"
      container_port   = 4141
      container_name   = "atlantis"
    }
  ] 
  updated_service = [
    for s in var.SERVICE :
    {
      name                             = s.name
      task_definition                  = s.task_definition
      desired_count                    = s.desired_count
      scheduling_strategy              = s.scheduling_strategy
      deployment_minimum_healthy_percent = s.deployment_minimum_healthy_percent
      deployment_maximum_percent       = s.deployment_maximum_percent
      subnets                          = s.subnets
      security_groups                  = s.security_groups
      assign_public_ip                 = s.assign_public_ip
      load_balancer = local.updated_load_balancer
    }
  ]
    # changing the ALN DNS inside Route53 Records variable 
  updated_record = ["${module.ALB.APPLICATION_LOAD_BALANCER_DNS_NAME}"]
  updated_Records = [
    for record in var.RECORDS :
    {
      name                  = record.name
      type                  = record.type
      ttl                   = record.ttl
      set_identifier        = record.set_identifier
      geolocation_routing_policy = record.geolocation_routing_policy
      latency_routing_policy     = record.latency_routing_policy
      failover_routing_policy    = record.failover_routing_policy
      weighted_routing_policy    = record.weighted_routing_policy
      alias                 = record.alias
      records               = local.updated_record
    }
  ]
  
}


###################### ECS ##############################
module "ECS" {
    #   providers = {
    #   aws = aws.var.REGION
    # }
  source                      = "git::https://github.com/scaleops/litmusscale-terraform-modules.git//modules/ECS_FARGATE?ref=module/v1.0"
  TAGS                        = var.TAGS
  COMMON_TAGS                 = local.common_tags
  LOG_GROUP_NAME              = var.LOG_GROUP_NAME
  RETENTION_DAYS              = var.RETENTION_DAYS
  CLUSTER_NAME                = var.CLUSTER_NAME
  KMS_KEY_ID                  = var.KMS_KEY_ID
  ECS_TASKS                   = var.ECS_TASKS
  SERVICE                     = local.updated_service

}

###################### ECS OUTPUTS ##############################


output "ECS_CLUSTER_ARN"{
  value = "${module.ECS.ECS_CLUSTER_ARN}"
}

output "FARGATE_SERVICE_NAME"{
  value = "${module.ECS.FARGATE_SERVICE_NAME}"
}
output "FARGATE_SERVICE_ID"{
  value = "${module.ECS.FARGATE_SERVICE_ID}"
}
output "FARGATE_TASK_DEFINATION"{
  value = "${module.ECS.FARGATE_TASK_DEFINATION}"
}


###################### ALB ##############################

module "ALB" {
  source      = "git::https://github.com/scaleops/litmusscale-terraform-modules.git//modules/ALB?ref=module/v1.0"
  COMMON_TAGS = local.common_tags
  TAGS        = var.TAGS
  ###############
  ### Application LoadBalancer
  ###############
  ALB_NAME               = var.ALB_NAME
  ALB_ACCESS_LOGS        = var.ALB_ACCESS_LOGS
  ALB_SUBNET_IDS         = var.ALB_SUBNET_IDS
  ALB_SECURITY_GROUP_IDS = var.ALB_SECURITY_GROUP_IDS
  ALB_INTERNAL           = var.ALB_INTERNAL
  ALB_VPC_ID             = var.ALB_VPC_ID
  ALB_TARGET_GROUPS      = var.ALB_TARGET_GROUPS
  ALB_HTTP_TCP_LISTENERS = var.ALB_HTTP_TCP_LISTENERS
  ALB_HTTPS_LISTENERS    = var.ALB_HTTPS_LISTENERS

  ALB_LISTENER_RULES_HTTP_REDIRECT       = var.ALB_LISTENER_RULES_HTTP_REDIRECT
  ALB_LISTENER_RULES_HTTP_FORWARD        = var.ALB_LISTENER_RULES_HTTP_FORWARD
  ALB_LISTENER_RULES_HTTP_FIXED_RESPONSE = var.ALB_LISTENER_RULES_HTTP_FIXED_RESPONSE

  ALB_LISTENER_RULES_HTTPS_REDIRECT       = var.ALB_LISTENER_RULES_HTTPS_REDIRECT
  ALB_LISTENER_RULES_HTTPS_FORWARD        = var.ALB_LISTENER_RULES_HTTPS_FORWARD
  ALB_LISTENER_RULES_HTTPS_FIXED_RESPONSE = var.ALB_LISTENER_RULES_HTTPS_FIXED_RESPONSE


  ALB_ENABLE_CROSS_ZONE_LOAD_BALANCING = var.ALB_ENABLE_CROSS_ZONE_LOAD_BALANCING
  ALB_ENABLE_DELETION_PROTECTION       = var.ALB_ENABLE_DELETION_PROTECTION
  ALB_ENABLE_HTTP2                     = var.ALB_ENABLE_HTTP2
  ALB_IP_ADDRESS_TYPE                  = var.ALB_IP_ADDRESS_TYPE
}
###################### ALB OUTPUTS ##############################


output "APPLICATION_LOAD_BALANCER" {
  value       = "${module.ALB.APPLICATION_LOAD_BALANCER}"
}
output "APPLICATION_LOAD_BALANCER_ARN" {
  value       = "${module.ALB.APPLICATION_LOAD_BALANCER_ARN}"
}
output "ALB_TARGET_GROUPS" {
  description = "list"
  value       = "${module.ALB.ALB_TARGET_GROUPS}"
}
output "ALB_TARGET_GROUPS_ARN" {
  description = "list"
  value       = "${module.ALB.ALB_TARGET_GROUPS_ARN}"
}
output "APPLICATION_LOAD_BALANCER_ZONE_ID" {
  value       = "${module.ALB.APPLICATION_LOAD_BALANCER_ZONE_ID}"
}

output "APPLICATION_LOAD_BALANCER_DNS_NAME" {
  value       = "${module.ALB.APPLICATION_LOAD_BALANCER_DNS_NAME}"
}

##################### ROUTE 53 ##############################
module "Route53" {
 
  source            = "./modules/Route53"
  COMMON_TAGS       = local.common_tags
  TAGS              = var.TAGS
  CREATE_ZONE       = var.CREATE_ZONE
  CREATE_RECORD     = var.CREATE_RECORD
  ZONE_NAME         = var.ZONE_NAME
  DESCRIPTION       = var.DESCRIPTION
  RECORDS           = local.updated_Records
  VPCS              = var.VPCS
  HOSTED_ZONE_ID    = var.HOSTED_ZONE_ID
}
###################### ROUTE 53 OUTPUTS ##############################

output "ROUTE53_ZONE_ARN" {
  value       = "${module.Route53.ROUTE53_ZONE_ARN}"
}
output "ROUTE53_ZONE_ID" {
  value       = "${module.Route53.ROUTE53_ZONE_ID}"
}
output "ROUTE53_ZONE_NAME_SERVERS" {
  value       = "${module.Route53.ROUTE53_ZONE_NAME_SERVERS}"
}
output "ROUTE53_RECORD_NAME" {
  value       = "${module.Route53.ROUTE53_RECORD_NAME}"
}
