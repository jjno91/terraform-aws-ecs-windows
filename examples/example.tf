variable "env" {
  default = "core-us-dev"
}

locals {
  tags = {
    Creator     = "Terraform"
    Environment = "${var.env}"
    Owner       = "my-team@my-company.com"
  }
}

module "ecs_windows" {
  source = "github.com/jjno91/terraform-aws-ecs-windows?ref=master"
  vpc_id = "my_vpc"
  env    = "${var.env}"
  tags   = "${local.tags}"
}
