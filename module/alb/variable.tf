
variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  description = "Public subnet IDs for ALB (min 2 required by AWS)"
  type        = list(string)
}

variable "target_port" {
  description = "Port that EC2 instances listen on (forwarded from ALB)"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "HTTP path for ALB health checks"
  type        = string
  default     = "/"
}

variable "access_logs_bucket" {
  description = "S3 bucket for ALB access logs — leave empty to disable"
  type        = string
  default     = ""
}
