############################ ECS ##############################
REGION = "{REGION}"
CLUSTER_NAME = "ltscale-Atlantis"
LOG_GROUP_NAME = "ltscale-Atlantis"
KMS_KEY_ID = "arn:aws:kms:{region}:{acc_id}:key/6bcdccf5-91c2-4a0f-ab22-272b90efda75"
RETENTION_DAYS = 7
ECS_TASKS = [
  {
    family         = "ltscale-Atlantis"
    cpu            = "256"
    memory         = "512"
    container_port = "4141"
    container_name = "atlantis"
    task_role_arn  = "arn:aws:iam::{ACCOINT_ID}:role/ecs_task_execution_role"
    execution_role_arn= "arn:aws:iam::{ACCOINT_ID}:role/ecs_task_execution_role"
    network_mode   = "awsvpc"
    container_definition = [
      {
        name      = "atlantis"
        image     = "ghcr.io/runatlantis/atlantis:latest"
        essential = true 
        portMappings = [
          {
            containerPort = 4141
            protocol      = "tcp"
            hostPort      = 4141
          }
        ]
        logConfiguration ={
             logDriver     = "awslogs"
             options = {
                awslogs-group = "ltscale-Atlantis"
                awslogs-stream-prefix = "usama-ecs"
                awslogs-region  = "{REGION}"
             }
        }
         environment= [
                {
                  name  = "ATLANTIS_ALLOW_REPO_CONFIG"
                  value = ""
                },
                {
                  name  = "ATLANTIS_LOG_LEVEL"
                  value = "debug"
                },
                {
                  name  = "ATLANTIS_PORT"
                  value = "4141"
                },
                {
                  name  = "ATLANTIS_ATLANTIS_URL"
                  value = ""
                },
                {
                  name  = "ATLANTIS_GH_USER"
                  value = "{GITHUB USERNAME}"
                },
                {
                  name  = "ATLANTIS_GITLAB_HOSTNAME"
                  value = "gitlab.com"
                },
                {
                  name  = "ATLANTIS_REPO_ALLOWLIST"
                  value = "github.com/{GITHUB USERNAME}/*"
                },
                {
                  name  = "ATLANTIS_HIDE_PREV_PLAN_COMMENTS"
                  value = "false"
                },
                {
                  name  = "ATLANTIS_GH_APP_ID"
                  value = ""
                },
                {
                  name  = "ATLANTIS_WRITE_GIT_CREDS"
                  value = "true"
                },
                {
                  name = "ATLANTIS_BITBUCKET_BASE_URL"
                  value = ""
                },
                 {
                  name = "ATLANTIS_BITBUCKET_USER"
                  value = ""
                },
                {
                  name = "ATLANTIS_GITLAB_USER"
                  value = ""
                },
                {
                  name  = "ATLANTIS_GH_TOKEN"
                  value = "{GIT_ACCESS_TOKEN}"
                },
                {
                  name  = "ATLANTIS_GH_WEBHOOK_SECRET"
                  value = "{GIT WEBHOOK SECRET}"
                },
                {
                  name = "ATLANTIS_REPO_CONFIG_JSON"
                  value = "{\"repos\":[{\"id\":\"/.*/\",\"allowed_overrides\":[\"apply_requirements\",\"workflow\"],\"allow_custom_workflows\":true}]}"
                },
                {
                  name = "ATLANTIS_ENABLE_POLICY_CHECKS"
                  value = "true"
                },
                {
                  name = "ATLANTIS_API_SECRET"
                  value = "{API_SECRET}"
                }
            ],
      }
    ]
  },
]
SERVICE = [
  {
    name                   = "ltscale-Atlantis"
    task_definition        = "ltscale-Atlantis"
    desired_count          = 1
    scheduling_strategy                = "REPLICA"
    deployment_minimum_healthy_percent = 50
    deployment_maximum_percent         = 200
    subnets          = ["subnet-06cf1b0b0ddce71cd","subnet-055e8e8d2bd16ba37"]
    security_groups  = ["sg-0eb3f06b2ca65e670"]
    assign_public_ip = true
    load_balancer = [
      {
          target_group_arn = ""
          container_name   = "atlantis"
          container_port   = 4141
      }
    ]
  },
]

############################ ALB ##############################
ALB_NAME = "ltscale-Atlantis"
ALB_SUBNET_IDS = ["subnet-06cf1b0b0ddce71cd","subnet-055e8e8d2bd16ba37"]
ALB_SECURITY_GROUP_IDS = ["sg-0eb3f06b2ca65e670"]
# ALB_ACCESS_LOGS = {
#     bucket              = "usama-ltscale"
#     prefix              = ""
#   }
ALB_TARGET_GROUPS = [
  {
      backend_protocol      = "HTTP"
      name                  = "ltscale-Atlantis"
      backend_port          = "80"
      target_type           = "ip"
      health_check = {
          enabled             = "true"
          interval            = "300"
          path                = "/"
          healthy_threshold   = "3"
          unhealthy_threshold = "3"
      }
  }
]
ALB_VPC_ID = "vpc-05b9dcd936886a1df"
ALB_HTTP_TCP_LISTENERS = [
  {
      port                = 80
      protocol            = "HTTP"
      target_group_index  = 0
  }
]
ALB_HTTPS_LISTENERS = [
  {
      port                = 443
      protocol            = "HTTPS"
      certificate_arn     = "arn:aws:acm:{REGION}:{ACCOINT_ID}:certificate/296766bd-42ad-41ce-be39-2df284878c6e"
      target_group_index  = 0
  }
]

############################ ROUTE 53 ##############################
CREATE_ZONE = false
CREATE_RECORD = true
HOSTED_ZONE_ID = ""
DESCRIPTION = "DNS name for atlantis load balancer"
ZONE_NAME = "LTScale.com"
VPCS = [
  {
    vpc_id      = "vpc-05b9dcd936886a1df"
    vpc_region  = "{REGION}"
    
  }
]
RECORDS = [
      {
        name      = "ltScaleatlantis"
        
        type      = "CNAME"
        ttl       = 300
        records   = ["alb-test-12839823.{REGION}.elb.amazonaws.com"]
        set_identifier = "dev"
        geolocation_routing_policy = {
        }
        latency_routing_policy = {
        }
        failover_routing_policy = {
        }
        weighted_routing_policy = {
             weight = 200
        }
        alias = {
        
        }
      }
    ]