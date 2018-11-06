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

variable "ami_name_filter" {
  description = "(optional) Used to lookup the AMI that will be used in the cluster launch template"
  default     = "Windows_Server-2016-English-Full-ECS_Optimized*"
}

variable "min_size" {
  description = "(optional) Minimum node count for ASG"
  default     = "2"
}

variable "max_size" {
  description = "(optional) Maximum node count for ASG"
  default     = "10"
}

variable "scaling_metric" {
  description = "(optional) ECS cluster metric used to calculate scaling operations"
  default     = "MemoryReservation"
}

variable "scaling_metric_period" {
  description = "(optional) https://www.terraform.io/docs/providers/aws/r/cloudwatch_metric_alarm.html#period"
  default     = "60"
}

variable "scaling_evaluation_periods" {
  description = "(optional) https://www.terraform.io/docs/providers/aws/r/cloudwatch_metric_alarm.html#evaluation_periods"
  default     = "2"
}

variable "scaling_high_bound" {
  description = "(optional) When scaling_metric is above this bound your cluster will scale up"
  default     = "90"
}

variable "scaling_low_bound" {
  description = "(optional) When scaling_metric is below this bound your cluster will scale down"
  default     = "75"
}

variable "scaling_adjustment" {
  description = "(optional) https://www.terraform.io/docs/providers/aws/r/autoscaling_policy.html#scaling_adjustment"
  default     = "1"
}

variable "scaling_cooldown" {
  description = "(optional) https://www.terraform.io/docs/providers/aws/r/autoscaling_policy.html#cooldown"
  default     = "180"
}
