############################  ECS  ############################
variable "REGION" {
    type    = string
    default = ""
}

variable "CLUSTER_NAME" {
        type = string
        default = ""

}
variable "LOG_GROUP_NAME" {
        type = string
        default = ""
}
variable "KMS_KEY_ID" {
        type = string
        default = ""
}

variable "RETENTION_DAYS" {
            type = number
            default = 7
            description = "retention days for logs to reside in log group"
}               
variable "ECS_TASKS" {
  description = "List of variables to define an ECS task."
  type = list(object({
    family         = string
    cpu            = string
    memory         = string
    container_port = string
    container_name = string
    task_role_arn  = string
    execution_role_arn= string
    network_mode   = string
    container_definition = list(object({
      name      = string
      image     = string
      essential = bool
      portMappings      = list(object({
        containerPort = number
        protocol      = string
        hostPort      = number
      }))
      logConfiguration =  object({
        logDriver     = string
        options       = object({
            awslogs-group = string
            awslogs-stream-prefix = string
            awslogs-region  = string
        })
      })
      environment = list(object({
        name = string
        value = string
      }))
    }))
  }))
  default = []
}

variable "SERVICE" {
  description = "List of variables to define a Fargate microservice."
  type = list(object({
    name                   = string
    task_definition        = string
    desired_count          = number
    scheduling_strategy                = string
    deployment_minimum_healthy_percent = number
    deployment_maximum_percent         = number
    subnets          = list(string)
    security_groups  = list(string)
    assign_public_ip = bool
    load_balancer = list(object({
      target_group_arn = string
      container_name   = string
      container_port   = number

    }))
  }))
  default = []

  }

variable "TAGS" {
  default = {
     "Name" = "usama-ltscale-tf",
  }
}

############################  ALB  ############################


 variable "ALB_SUBNET_IDS" {
   type = list(string)
   default = []
 }
 variable "ALB_SECURITY_GROUP_IDS" {
  type = list(string)
   default = []
 }
 variable "ALB_INTERNAL" {
  type = bool
   default = false
 }
 variable "ALB_IDLE_TIMEOUT" {
  type = number
   default = 60
 }
 variable "ALB_ENABLE_CROSS_ZONE_LOAD_BALANCING" {
  type = bool
   default = false
 }
 variable "ALB_ENABLE_DELETION_PROTECTION" {
  type = bool
   default = false
 }
 variable "ALB_ENABLE_HTTP2" {
  type = bool
   default = false
 }
 variable "ALB_IP_ADDRESS_TYPE" {
   description = "The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack"
   type        = string
   default     = "ipv4"
 }
 variable "ALB_DROP_INVALID_HEADER_FIELDS" {
  type = bool
   default = false
 }
variable "ALB_ACCESS_LOGS" {
  type        = object({
    # bucket              = string
    # prefix              = string
  })
  default = {
    # bucket              = ""
    # prefix              = ""
  }
}
 variable "ALB_SUBNET_MAPPING" {
  type = list(string)
   default = []
 }
 variable "ALB_NAME" {
  type = string
  default = "alb-test"
 }
 variable "ALB_LOAD_BALANCER_CREATE_TIMEOUT" {
   default = "10m"
 }
 variable "ALB_LOAD_BALANCER_UPDATE_TIMEOUT" {
   default = "10m"
 }
 variable "ALB_LOAD_BALANCER_DELETE_TIMEOUT" {
   default = "10m"
 }
# ###################
 ###### Target Groups
 ###################
variable "ALB_TARGET_GROUPS" {
  type = list(object({
      backend_protocol      = string
      name                  = string
      backend_port          = number
      target_type           = string
      health_check          = object({
          enabled             = string
          interval            = string
          path                = string
          healthy_threshold   = string
          unhealthy_threshold = string
      })
  }))
  default = []
}
 variable "ALB_VPC_ID" {
  type = string
  default = ""
 }
variable "ALB_HTTP_TCP_LISTENERS" {
  type = list(object({
      port                = number
      protocol            = string
      target_group_index  = number
  }))
  default = []
}
variable "ALB_HTTPS_LISTENERS" {
  type = list(object({
      port                = number
      protocol            = string
      certificate_arn     = string
      target_group_index  = number
  }))
  default = []
}
 variable "ALB_LISTENER_SSL_POLICY_DEFAULT" {
   default = "ELBSecurityPolicy-2016-08"
 }

############################################
## Listeners Rules For HTTP and HTTPS  #####
############################################

variable "ALB_LISTENER_RULES_HTTP_FORWARD" {
  type = list(object({
    listener_index     = number
    priority           = number
    target_group_index = number
    forward = list(object({
      target_groups = list(object({
        target_group_index = number
        weight             = number
      }))
      stickiness = object({
        enabled  = bool
        duration = number
      })
    }))

    path_pattern        = list(string)
    host_header         = list(string)
    http_request_method = list(string)
    source_ip           = list(string)
    http_header = list(object({
      http_header_name = string
      values           = list(string)
    }))
    query_string = list(object({
      key   = string
      value = string
    }))
  }))
  default = []
}
variable "ALB_LISTENER_RULES_HTTP_REDIRECT" {
  type = list(object({
    listener_index      = number
    priority            = number
    status_code         = string
    host                = string
    path                = string
    port                = number
    protocol            = string
    query               = string

    path_pattern        = list(string)
    host_header         = list(string)
    http_request_method = list(string)
    source_ip           = list(string)
    http_header = list(object({
      http_header_name = string
      values           = list(string)
    }))
    query_string = list(object({
      key   = string
      value = string
    }))
  }))
 default = []
}
variable "ALB_LISTENER_RULES_HTTP_FIXED_RESPONSE" {
  type = list(object({
    listener_index = number
    priority       = number
    content_type   = string
    message_body   = string
    status_code    = number

    path_pattern        = list(string)
    host_header         = list(string)
    http_request_method = list(string)
    source_ip           = list(string)
    http_header = list(object({
      http_header_name = string
      values           = list(string)
    }))
    query_string = list(object({
      key   = string
      value = string
    }))
  }))
  default = []
}

variable "ALB_LISTENER_RULES_HTTPS_FORWARD" {
  type = list(object({
    listener_index     = number
    priority           = number
    target_group_index = number
    forward = list(object({
      target_groups = list(object({
        target_group_index = number
        weight             = number
      }))
      stickiness = object({
        enabled  = bool
        duration = number
      })
    }))
    path_pattern        = list(string)
    host_header         = list(string)
    http_request_method = list(string)
    source_ip           = list(string)
    http_header = list(object({
      http_header_name = string
      values           = list(string)
    }))
    query_string = list(object({
      key   = string
      value = string
    }))
  }))
  default = []
}
variable "ALB_LISTENER_RULES_HTTPS_REDIRECT" {
  type = list(object({
    listener_index      = number
    priority            = number
    status_code         = string
    host                = string
    path                = string
    port                = number
    protocol            = string
    query               = string

    path_pattern        = list(string)
    host_header         = list(string)
    http_request_method = list(string)
    source_ip           = list(string)
    http_header = list(object({
      http_header_name = string
      values           = list(string)
    }))
    query_string = list(object({
      key   = string
      value = string
    }))
  }))
  default = []
}
variable "ALB_LISTENER_RULES_HTTPS_FIXED_RESPONSE" {
  type = list(object({
    listener_index = number
    priority       = number
    content_type   = string
    message_body   = string
    status_code    = number

    path_pattern        = list(string)
    host_header         = list(string)
    http_request_method = list(string)
    source_ip           = list(string)
    http_header = list(object({
      http_header_name = string
      values           = list(string)
    }))
    query_string = list(object({
      key   = string
      value = string
    }))
  }))
  default = []
}
############################  ROUTE 53  ############################
variable "CREATE_ZONE" {
    type    = bool
    default = true
}
variable "HOSTED_ZONE_ID" {
  type = string
}
variable "CREATE_RECORD" {
    type        = bool
    default     = true
}
variable "DESCRIPTION" {
    type = string
    default = null
}
variable "ZONE_NAME" {
    type        = string
}
variable "VPCS" { 
    type = list(object({
        vpc_id      = string
        vpc_region  = string
    }))
  default = []
}
variable "RECORDS" {
  type        = list(object({
      name      = string
      type      = string
      ttl       = number
      records   = list(string)
      set_identifier = string
      geolocation_routing_policy = object({
          #  continent = string
      })
      latency_routing_policy = object({
            # region = string
      })
      failover_routing_policy = object({
        #  type = string
      })
      weighted_routing_policy = object({
         weight = number
      })
      alias     = object({
          # name      = string
          # zone_id   = string
      })
  }))
  default     = []
}
