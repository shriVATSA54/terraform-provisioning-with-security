variable "vpc_id" {
  type = string
}
variable "subnet_ids" {
  description = "Public subnet IDs where ASG launches instances"
  type        = list(string)
}

variable "target_group_arns" {
  description = "ALB target group ARNs to attach to the ASG"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security group ID of the ALB (EC2 SG allows inbound from this)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the launch template"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name — leave empty to disable SSH key"
  type        = string
  default     = ""
}

variable "asg_min_size" {
  type    = number
  default = 1
}

variable "asg_max_size" {
  type    = number
  default = 3
}

variable "asg_desired" {
  type    = number
  default = 2
}

variable "on_demand_base" {
  description = "Minimum on-demand instances regardless of spot availability"
  type        = number
  default     = 1
}

variable "on_demand_pct_above" {
  description = "% of on-demand above the base (30 = 30% on-demand / 70% spot)"
  type        = number
  default     = 30
}

variable "root_volume_size_gb" {
  description = "Root EBS volume size in GB (gp3)"
  type        = number
  default     = 8
}

variable "enable_detailed_monitoring" {
  description = "Enable EC2 detailed monitoring (1-minute intervals; extra cost)"
  type        = bool
  default     = false
}

variable "ssh_cidr" {
  description = "CIDR to allow SSH from — set to empty string to disable"
  type        = string
  default     = ""
}
