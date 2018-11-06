variable "env" {
  description = "(optional) Unique name of your Terraform environment to be used for naming and tagging resources"
  default     = "default"
}

variable "tags" {
  description = "(optional) Additional tags to be applied to all resources"
  default     = {}
}

variable "subnet_tags" {
  description = "(optional) Tags used to identify your target subnets with selected VPC"

  default = {
    Type = "Private"
  }
}

variable "vpc_id" {
  description = "(required) ID of the VPC that your ECS cluster will be deployed to"
  default     = ""
}

variable "instance_type" {
  description = "(optional) EC2 instance type for the ASG of your cluster"
  default     = "m5.large"
}

variable "min_size" {
  description = "(optional) Minimum node count for ASG"
  default     = "2"
}

variable "max_size" {
  description = "(optional) Maximum node count for ASG"
  default     = "10"
}
