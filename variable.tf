
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the 3 public subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
variable "private_subnet_cidrs" {
  description = "CIDR blocks for the 3 public subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24", "10.0.7.0/24"]
}

variable "availability_zones" {
  description = "List of 3 AZs for HA deployment"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "ami_id" {
  description = "AMI ID for the launch template (e.g. Amazon Linux 2023)"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name for SSH access (leave empty to disable)"
  type        = string
  default     = ""
}

variable "asg_min_size" {
  description = "Minimum number of instances in the ASG"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of instances in the ASG"
  type        = number
  default     = 6
}

variable "asg_desired" {
  description = "Desired number of instances in the ASG"
  type        = number
  default     = 3
}

variable "on_demand_base" {
  description = "Absolute minimum on-demand instances (baseline capacity)"
  type        = number
  default     = 1
}

variable "on_demand_pct_above" {
  description = "Percentage of on-demand instances above the base (30 = 30% on-demand, 70% spot)"
  type        = number
  default     = 30
}