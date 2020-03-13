data "aws_region" "region" {
  name = var.region
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

locals {
  docker_environment = [
    {
      "name"  = "SERVICE_NAME"
      "value" = "strongdm-${var.enable_sdm_gateway == "true" ? "gateway" : "relay"}"
    },
    {
      "name"  = "SDM_ADMIN_TOKEN"
      "value" = var.sdm_admin_token
    },
    {
      "name"  = "ENABLE_SDM_GATEWAY"
      "value" = "%{ if var.enable_sdm_gateway != "null" }${var.enable_sdm_gateway}%{ else }false%{ endif }"
    },
    {
      "name"  = "SDM_GATEWAY_LISTEN_APP_PORT"
      "value" = var.sdm_gateway_listen_app_port
    },
  ]
}
