variable "docker_image" {
  type        = string
  description = "Docker image to use (default: asicsdigital/strongdm:build-34 )"
  default     = "asicsdigital/strongdm:build-34"
}

variable "ecs_cluster_arn" {
  type        = string
  description = "ARN of ECS cluster in which the service will be deployed"
}

variable "region" {
  type        = string
  description = "AWS region in which ECS cluster is located (default is 'us-east-1')"
  default     = "us-east-1"
}

variable "sdm_admin_token" {
  type = string
  description = "SDM_ADMIN_TOKEN: admin tokens to provide tokenized account access for fully automated strongDM use."
}

variable "vpc_id" {
  type        = string
  description = "ID of VPC in which ECS cluster is located"
}

variable "ecs_desired_count" {
  description = "Desired number of containers in the task (default 1)"
  default     = 2
}

variable "ecs_deployment_maximum_percent" {
  default     = "200"
  description = "Upper limit in percentage of tasks that can be running during a deployment (default 200)"
}

variable "ecs_deployment_minimum_healthy_percent" {
  default     = "100"
  description = "Lower limit in percentage of tasks that must remain healthy during a deployment (default 100)"
}

variable "ecs_health_check_grace_period" {
  default     = "0"
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 1800. (default 0)"
}

variable "docker_command" {
  description = "String to override CMD in Docker container (default \"\")"
  default     = ""
}

variable "docker_memory" {
  type        = string
  description = "Hard limit on memory use for task container (default 256)"
  default     = "256"
}

variable "docker_memory_reservation" {
  type        = string
  description = "Soft limit on memory use for task container (default 128)"
  default     = "128"
}

variable "docker_mount_points" {
  type        = list
  description = "List of mount point maps of format { \"sourceVolume\" = \"vol_name\", \"containerPath\" = \"path\", [\"readOnly\" = \"true or false\" ] }"
  default     = []
}

variable "ecs_data_volume_path" {
  description = "Path to volume on ECS node to be defined as a \"data\" volume (default \"/opt/data\")"
  default     = "/opt/data"
}

#variable "docker_environment" {
#  type        = "list"
#  description = "List of environment maps of format { \"name\" = \"var_name\", \"value\" = \"var_value\" }"
#  default     = []
#}

variable "network_mode" {
  description = "Docker network mode for task (default \"bridge\")"
  default     = "bridge"
}

variable "service_identifier" {
  type        = string
  description = "Unique identifier for this pganalyze service (used in log prefix, service name etc.)"
  default     = "strongdm"
}

variable "task_identifier" {
  description = "Unique identifier for this pganalyze task (used in log prefix, service name etc.)"
  default     = "relay"
}

variable "log_group_name" {
  type        = string
  description = "Name for CloudWatch Log Group that will receive collector logs (must be unique, default is created from service_identifier and task_identifier)"
  default     = ""
}

variable "extra_task_policy_arns" {
  type        = list
  description = "List of ARNs of IAM policies to be attached to the ECS task role (in addition to the default policy, so cannot be more than 9 ARNs)"
  default     = []
}

variable "ecs_placement_strategy_type" {
  description = "Placement strategy to use when distributing tasks (default binpack)"
  default     = "binpack"
}

variable "ecs_placement_strategy_field" {
  description = "Container metadata field to use when distributing tasks (default memory)"
  default     = "memory"
}

variable "ecs_log_retention" {
  description = "Number of days of ECS task logs to retain (default 3)"
  default     = 3
}

variable "enable_sdm_gateway" {
  type = string
  description = "Should the sdm relay also be a gateway? default false"
  default     = "false"
}

variable "sdm_gateway_listen_app_port" {
  type = string
  description = "Port for SDM gateway to listen on inside container"
  default     = "5000"
}

variable "curl_metadata_timeout" {
  description = "Time in seconds to time out the curl for EC2 metadata"
  default     = 30
}

variable "ecs_cluster_extra_access_sg_id" {
  description = "ECS extra access Security Group ID to attach a security_group_rule to for strongdm gateway inbound traffic. Note cannot contain inline rule blocks."
  default     = ""
}

variable "aws_profile" {
  description = "Which AWS profile is should be used? Defaults to \"default\""
  default     = "default"
}
