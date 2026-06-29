output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.name
}

output "asg_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.arn
}

output "launch_template_id" {
  description = "ID of the Launch Template"
  value       = aws_launch_template.lt.id
}

output "launch_template_latest_version" {
  description = "Latest version number of the Launch Template"
  value       = aws_launch_template.lt.latest_version
}

output "ec2_sg_id" {
  description = "Security group ID attached to EC2 instances"
  value       = aws_security_group.ec2.id
}
