# terraform-aws-strongdm
Terraform Module for deploying [strongDM](https://www.strongdm.com) Relays on ECS Clusters

In order to use this module you will need to generate a SDM_ADMIN_TOKEN. Set up for admin tokens can be found [here](https://docs.strongdm.com/docs/guides/admin-tokens/).

## Task Placement

By default, this service first tries to spread strongDM relays across the ECS cluster by host; the module also allows you to specify a secondary placement strategy, which is set by default to binpack based on memory.

----------------------

#### Required
- `region` - AWS region in which the EC2 Container Service cluster is located
- `ecs_cluster` - EC2 Container Service cluster in which the service will be deployed (must already exist, the module will not create it).
- `vpc_id` - ID of VPC in which ECS cluster is located
- `ecs_cluster_arn` - ARN of ECS cluster in which the service will be deployed
- `sdm_admin_token` - SDM_ADMIN_TOKEN: admin tokens to provide tokenized account access for fully automated strongDM use.

#### Optional

- `service_identifier` - Unique identifier for the service, used in naming resources (default: `strongdm`).
- `task_identifier` - Unique identifier for the task, used in naming resources (default: `relay`).
- `docker_image` - Docker image specification (default: asicsdigital/strongdm:latest ).
- `ecs_desired_count` - Desired number of containers in the task (default 2)
- `docker_command` - String to override CMD in Docker container (default "")
- `docker_memory` - Hard limit on memory use for task container (default 256)
- `docker_memory_reservation` - Soft limit on memory use for task container (default 128)
- `docker_port_mappings` - List of port mapping maps of format `{ "containerPort" = integer, [ "hostPort" = integer, "protocol" = "tcp or udp" ] }` (default [])
- `docker_mount_points` -  List of mount point maps of format `{ "sourceVolume" = "vol_name", "containerPath" = "path", ["readOnly" = "true or false" ] }` (default [])
- `ecs_data_volume_path` - Path to volume on ECS node to be defined as a "data" volume (default "/opt/data")"
- `docker_environment` - List of environment maps of format `{ "name" = "var_name", "value" = "var_value" }` (default [])
- `network_mode` - Docker network mode for task (default "bridge")
- `log_group_name` - Name for CloudWatch Log Group that will receive collector logs (must be unique, default is created from service_identifier and task_identifier)
- `extra_task_policy_arns` - List of ARNs of IAM policies to be attached to the ECS task role (in addition to the default policy, so cannot be more than 9 ARNs)
- `ecs_deployment_maximum_percent` - Upper limit in percentage of tasks that can be running during a deployment (default 200)
- `ecs_deployment_minimum_healthy_percent` - Lower limit in percentage of tasks that must remain healthy during a deployment (default 100)
- `ecs_health_check_grace_period` - Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 1800. (default 0)
- `ecs_placement_strategy_type` - Placement strategy to use when distributing tasks (default binpack)
- `ecs_placement_strategy_field` - Container metadata field to use when distributing tasks (default memory)
- `ecs_log_retention` - Number of days of ECS task logs to retain (default 3)

Usage
-----

```hcl

module "ecs_strongdm" {
  source             = "github.com/asicsdigital/terraform-aws-strongdm:v1.0.0"
  region             = "${data.aws_region.current.name}"
  vpc_id             = "${data.vpc.my_vpc.vpc_id}"
  ecs_cluster_arn    = "${data.aws_ecs_cluster.my_cluster.arn}"
  task_identifier    = "relay01"
  sdm_admin_token    = "<SDM_ADMIN_TOKEN>"
}


```

#### Docker Image

This module defaults to use the `asicsdigital/strongdm:latest` Docker image. This Image is built from the Dockerfile in this repo, using the command script in `files/entrypoint.sh` It should work with no changes needed, but should you wish to use the upstream `quay.io/sdmrepo/relay` image, or a custom image, you can pass in the image name to the `docker_image` prameter.

Outputs
=======

FIXME add some outputs

Authors
=======

* [Tim Hartmann](https://github.com/tfhartmann)

Thank you to the StrongDM team for all the help!  https://github.com/strongdm

Changelog
=========

1.0.0 - Initial release.

License
=======

This software is released under the MIT License (see `LICENSE`).
