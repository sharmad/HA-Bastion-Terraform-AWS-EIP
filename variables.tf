variable "region" {
    type = "string"
    description = "AWS region in which the Bastion should be deployed"
}

variable "project" {
    type = "string"
    description = "Name of the project these resources are being created in"
}

variable "environment" {
    type = "string"
    description = "dev, test, production, etc"
}

variable "instance_type" {
    type = "string"
    description = "Instance type of the Bastion host"
}

variable "max_size" {
    type = "string"
    description = "Max number of bastion instances running simultaneously"
    default = "1"
}

variable "min_size" {
    type = "string"
    description = "Min number of bastion instances running simultaneously"
    default = "1"
}

variable "desired_capacity" {
    type = "string"
    description = "The desired number of bastion instances that should be running at any time"
    default     = "1"
}

variable "health_check_grace_period" {
    type = "string"
    description = "Time (seconds) to wait after instance launches before health-checking"
}

variable "cooldown_period" {
    type = "string"
    description = "Time (seconds) to wait before another scaling activity can start."
}

variable "public_ssh_key" {
    type = "string"
}

variable "security_group_ids" {
    type = "list"
    description = "List of security groups to apply to the instances"
}

variable "subnet_ids" {
    type = "list"
}

variable "volume_type" {
  description = "Root volume type"
}

variable "volume_size" {
  description = "Root volume size (GB)"
}

variable "dns_zone_id" {
  description = "DNS hosted zone"
}

variable "domain" {
  description = "DNS domain name"
}

variable "ttl" {
  description = "time to live (seconds)"
}
