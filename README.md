# Highly Available Bastion Host in AWS implemented with Terraform

A module to create a HA Bastion Host on AWS which runs in an Autoscaling Group (ASG).  

![alt text](https://docs.aws.amazon.com/quickstart/latest/linux-bastion/images/linux-bastion-hosts-on-aws-architecture.png)

Make sure that the subnets in your custom VPC are in separate AZs.  
Remember: One subnet = one AZ. But one AZ is not one subnet, if that makes sense.  
So for US-East-1 region, make sure at a minimum 2 subnets are spread across 2 different AZs (US-East-1a, US-East-1b).  
If one availability zone goes down, the autoscaling group will ensure that the Bastion host gets launched in the other AZ.


# INPUT
```
region:                     AWS region in which the Bastion should be deployed
project:                    Name of the project these resources are being created in
environment:                dev, test, production, etc
instance_type:              Instance type of the Bastion host
max_size:                   Max number of bastion instances running simultaneously
min_size:                   Min number of bastion instances running simultaneously
desired_capacity:           The desired number of bastion instances that should be running at any time
health_check_grace_period:  Time (seconds) to wait after instance launches before health-checking
cooldown_period:            Time (seconds) to wait before another scaling activity can start
public_ssh_key:             Public half of SSH key
security_group_ids:         List of security groups to apply to the instances
subnet_ids:                 A list of all the subnet IDs for the Autoscaling Group to launch the Bastion across
volume_type:                Root volume type
volume_size:                Root volume size (GB)
dns_zone_id:                DNS hosted zone from Route53
ttl:                        DNS cache time to live (seconds)
```
