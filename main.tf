#################################################
# ECS
#################################################

resource "aws_ecs_cluster" "this" {
  name = "${var.env}-windows"
}

#################################################
# EC2
#################################################

data "aws_ami" "this" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["*amazon-ecs-optimized*"]
  }
}

data "aws_subnet_ids" "this" {
  vpc_id = "${var.vpc_id}"
  tags   = "${var.subnet_tags}"
}

locals {
  userdata = <<EOF
<powershell>
Import-Module ECSTools
Initialize-ECSAgent -Cluster "${aws_ecs_cluster.this.id}" -EnableTaskIAMRole
</powershell>
EOF
}

resource "aws_launch_template" "this" {
  image_id               = "${data.aws_ami.this.image_id}"
  instance_type          = "${var.instance_type}"
  ebs_optimized          = true
  user_data              = "${base64encode(local.userdata)}"
  vpc_security_group_ids = ["${aws_security_group.this.id}"]
  tags                   = "${merge(map("Name", var.env), var.tags)}"

  iam_instance_profile {
    name = "${aws_iam_instance_profile.this.name}"
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "volume"
    tags          = "${merge(map("Name", var.env), var.tags)}"
  }

  tag_specifications {
    resource_type = "instance"
    tags          = "${merge(map("Name", var.env), var.tags)}"
  }
}

resource "aws_autoscaling_group" "this" {
  min_size            = "${var.min_size}"
  max_size            = "${var.max_size}"
  vpc_zone_identifier = ["${data.aws_subnet_ids.this.ids}"]
  tags                = "${merge(map("Name", var.env), var.tags)}"

  launch_template = {
    id      = "${aws_launch_template.this.id}"
    version = "$$Latest"
  }

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]
}

#################################################
# IAM
#################################################

data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.env}-ecs-windows"
  assume_role_policy = "${data.aws_iam_policy_document.this.json}"
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  role       = "${aws_iam_role.ecs-instance-role.name}"
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.env}-ecs-windows"
  role = "${aws_iam_role.this.name}"
}

#################################################
# Security Group
#################################################

resource "aws_security_group" "this" {
  vpc_id = "${var.vpc_id}"
  tags   = "${merge(map("Name", "${var.env}-ecs-windows"), var.tags)}"
}

resource "aws_security_group_rule" "ingress" {
  description              = "ingress self"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.this.id}"
  source_security_group_id = "${aws_security_group.this.id}"
}

resource "aws_security_group_rule" "egress" {
  description              = "egress self"
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.this.id}"
  source_security_group_id = "${aws_security_group.this.id}"
}
