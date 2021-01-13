# ECS SERVICE

locals {
  docker_command_override = ${length(var.docker_command) > 0 ? "\"command\": [\"${var.docker_command}\"]," : ""}
}

data "template_file" "container_definition" {
  template = file("${path.module}/files/container_definition.json")

  vars = {
    service_identifier    = var.service_identifier
    task_identifier       = var.task_identifier
    image                 = var.docker_image
    memory                = var.docker_memory
    memory_reservation    = var.docker_memory_reservation
    command_override      = local.docker_command_override
    environment           = jsonencode(local.docker_environment)
    mount_points          = jsonencode(var.docker_mount_points)
    awslogs_region        = data.aws_region.region.name
    awslogs_group         = "${var.service_identifier}-${var.task_identifier}"
    awslogs_stream_prefix = var.service_identifier
    app_port              = var.sdm_gateway_listen_app_port
  }
}

resource "aws_ecs_task_definition" "task" {
  family                = "${var.service_identifier}-${var.task_identifier}"
  container_definitions = data.template_file.container_definition.rendered
  network_mode          = var.network_mode
  task_role_arn         = aws_iam_role.task.arn

  volume {
    name      = "data"
    host_path = var.ecs_data_volume_path
  }
}

resource "aws_ecs_service" "service" {
  name                               = "${var.service_identifier}-${var.task_identifier}-service"
  cluster                            = var.ecs_cluster_arn
  task_definition                    = aws_ecs_task_definition.task.arn
  desired_count                      = var.ecs_desired_count
  deployment_maximum_percent         = var.ecs_deployment_maximum_percent
  deployment_minimum_healthy_percent = var.ecs_deployment_minimum_healthy_percent
  health_check_grace_period_seconds  = var.ecs_health_check_grace_period

  ordered_placement_strategy {
    type  = "spread"
    field = "host"
  }

  ordered_placement_strategy {
    type  = var.ecs_placement_strategy_type
    field = var.ecs_placement_strategy_field
  }

  depends_on = [aws_iam_role.service]
}

resource "aws_cloudwatch_log_group" "task" {
  name              = "${var.service_identifier}-${var.task_identifier}"
  retention_in_days = var.ecs_log_retention
}

resource "aws_security_group_rule" "gateway_inbound_traffic" {
  count             = var.enable_sdm_gateway == "true" ? 1 : 0
  from_port         = var.sdm_gateway_listen_app_port
  protocol          = "tcp"
  security_group_id = var.ecs_cluster_extra_access_sg_id
  to_port           = var.sdm_gateway_listen_app_port
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}
