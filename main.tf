terraform {
    required_version = ">= 0.11.3"
}


provider "aws" {
    region     = "${var.region}"
}


resource "aws_eip" "bastion_eip" {
  vpc = "true"
}


resource "aws_route53_record" "bastion_dns_record" {
  zone_id = "${var.dns_zone_id}"
  name = "${var.domain}"
  type = "A"
  records = ["${aws_eip.bastion_eip.public_ip}"]
  ttl = "${var.ttl}"
}


resource "aws_iam_role" "bastion_iam_role" {
  name = "${var.project}_${var.environment}_bastion_iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_policy" "bastion_iam_policy" {
  name        = "${var.project}_${var.environment}_bastion_iam_policy"
  path        = "/"
  description = "${var.project}_${var.environment} Bastion IAM Policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1477071439000",
      "Effect": "Allow",
      "Action": [
        "ec2:AssociateAddress"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "bastion_attach_iam_policy" {
  role       = "${aws_iam_role.bastion_iam_role.name}"
  policy_arn = "${aws_iam_policy.bastion_iam_policy.arn}"
}


resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name = "${var.project}_${var.environment}_bastion_instance_profile"
  role = "${aws_iam_role.bastion_iam_role.name}"
}


data "aws_ami" "amazon_linux_ami" {
    most_recent      = true
    name_regex = "amzn-ami-hvm-*"
    owners     = ["amazon"]
    filter {
       name   = "architecture"
       values = ["x86_64"]
    }
    filter {
       name   = "image-type"
       values = ["machine"]
    }
    filter {
       name   = "state"
       values = ["available"]
    }
    filter {
       name   = "virtualization-type"
       values = ["hvm"]
    }
    filter {
       name   = "hypervisor"
       values = ["xen"]
    }
    filter {
       name   = "root-device-type"
       values = ["ebs"]
    }
}


data "template_file" "bastion_user_data" {
  template = "${file("${path.module}/bastion_userdata.sh")}"

  vars {
    REGION = "${var.region}"
    EIP_ID = "${aws_eip.bastion_eip.id}"
  }
}


resource "aws_key_pair" "bastion_key_pair" {
    key_name_prefix = "bastion-"
    public_key      = "${var.public_ssh_key}"
}


resource "aws_launch_configuration" "bastion_launch_config" {
    name_prefix                 = "bastion-"
    image_id                    = "${data.aws_ami.amazon_linux_ami.id}"
    instance_type               = "${var.instance_type}"
    iam_instance_profile        = "${aws_iam_instance_profile.bastion_instance_profile.name}"
    associate_public_ip_address = false
    key_name                    = "${aws_key_pair.bastion_key_pair.key_name}"
    security_groups             = ["${var.security_group_ids}"]
    enable_monitoring           = true

    root_block_device {
      volume_type = "${var.volume_type}"
      volume_size = "${var.volume_size}"
    }

    lifecycle {
        create_before_destroy = true
    }
}


resource "aws_autoscaling_group" "bastion_asg" {
    name_prefix               = "Bastion-"
    max_size                  = "${var.max_size}"
    min_size                  = "${var.min_size}"
    desired_capacity          = "${var.desired_capacity}"
    default_cooldown          = "${var.cooldown_period}"
    launch_configuration      = "${aws_launch_configuration.bastion_launch_config.name}"
    health_check_grace_period = "${var.health_check_grace_period }"
    health_check_type         = "EC2"
    vpc_zone_identifier       = ["${var.subnet_ids}"]
    lifecycle {
        create_before_destroy = true
    }
    tag {
        key                 = "Name"
        value               = "Bastion"
        propagate_at_launch = true
    }
    tag {
        key                 = "Environment"
        value               = "${var.environment}"
        propagate_at_launch = true
    }
}
