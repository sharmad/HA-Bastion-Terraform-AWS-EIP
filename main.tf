terraform {
    required_version = ">= 0.11.3"
}


provider "aws" {
    region     = "${var.region}"
}


resource "aws_eip" "bastion_eip" {
  vpc = "true"
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


resource "aws_launch_configuration" "bastion_launch_config" {
    name_prefix                 = "bastion-"
    image_id                    = "${data.aws_ami.amazon_linux_ami.id}"
    instance_type               = "${var.instance_type}"
    iam_instance_profile        = "${aws_iam_instance_profile.bastion_instance_profile.name}"
    associate_public_ip_address = false
    key_name                    = "${aws_key_pair.bastion_key_pair.key_name}"
    security_groups             = ["${var.security_group_ids}"]
    enable_monitoring           = true

}


resource "aws_autoscaling_group" "bastion_asg" {
    name_prefix               = "Bastion-"
    max_size                  = "${var.max_size}"
    min_size                  = "${var.min_size}"
    desired_capacity          = "${var.desired_capacity}"
    default_cooldown          = "${var.cooldown_period}"
    launch_configuration      = "${aws_launch_configuration.bastion_launch_config.name}"
}
