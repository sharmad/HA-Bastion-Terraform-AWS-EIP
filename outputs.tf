output "ami_id" {
    value = "${data.aws_ami.amazon_linux_ami.id}"
    description = "AMI ID of the Bastion"
}

output "launch_configuration_id" {
    value = "${aws_launch_configuration.bastion_launch_config.id}"
    description = "Launch configuration ID of the Bastion"
}

output "auto_scaling_group_id" {
    value = "${aws_autoscaling_group.bastion_asg.id}"
    description = "Auto scaling group id of the Bastion"
}

output "bastion_eip_address" {
  value       = "${aws_eip.bastion_eip.public_ip}"
  description = "Bastion Host's Elastic IP Address"
}

output "bastion_dns_name" {
  value       = "${aws_route53_record.bastion_dns_record.fqdn}"
  description = "Bastion Host's fully qualified domain name"
}

output "bastion_role_arn" {
  value       = "${aws_iam_role.bastion_iam_role.arn}"
  description = "Bastion Host's IAM role ARN"
}

output "bastion_instance_profile_arn" {
  value       = "${aws_iam_instance_profile.bastion_instance_profile.arn}"
  description = "Bastion Host's EC2 instance profile ARN"
}

output "bastion_instance_profile_name" {
  value       = "${aws_iam_instance_profile.bastion_instance_profile.name}"
  description = "Bastion Host's EC2 instance profile name"
}
