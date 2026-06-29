resource "aws_security_group" "ec2" {
  name        = "sgec2"
  description = "Allow traffic from ALB only; all outbound"
  vpc_id      = var.vpc_id
  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  dynamic "ingress" {
    for_each = var.ssh_cidr != "" ? [1] : []
    content {
      description = "SSH access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.ssh_cidr]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags =  {
    Name = "training-sg"
  }
}

resource "aws_launch_template" "lt" {
  name_prefix            = "training-launch-template"
  image_id               = var.ami_id
  instance_type          = "t3.nano"
  key_name               = var.key_name != "" ? var.key_name : null
  vpc_security_group_ids = [aws_security_group.ec2.id]

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_type           = "gp3"
      volume_size           = var.root_volume_size_gb
      iops                  = 3000
      throughput            = 125
      encrypted             = true
      delete_on_termination = true
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tag_specifications {
    resource_type = "instance"
    tags =  {
      Name = "instance-launch"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name       = "root-vol"
      VolumeType = "gp3"
    }
  }

  tags =  {
    Name = "lt"
  }
  # Always create a new version before destroying the old one
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "this" {
  name                = "-asg"
  vpc_zone_identifier = var.subnet_ids

  min_size         = var.asg_min_size
  max_size         = var.asg_max_size
  desired_capacity = var.asg_desired

  target_group_arns         = var.target_group_arns
  health_check_type         = "ELB"
  health_check_grace_period = 120

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = var.on_demand_base
      on_demand_percentage_above_base_capacity = var.on_demand_pct_above
      spot_allocation_strategy                 = "lowest-price"
      spot_instance_pools                      = 3
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.lt.id
        version            = "$Latest"
      }

      override {
        instance_type = "t2.nano"
      }
      override {
        instance_type = "t3.nano"
      }
      override {
        instance_type = "t2.micro"
      }
    }
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
      instance_warmup        = 120
    }
  }

  default_instance_warmup = 120

  dynamic "tag" {
    for_each =  {
      Name = "asg-instance"
      ASG  = "asg"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  lifecycle {
    ignore_changes = [desired_capacity]
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out"
  autoscaling_group_name = aws_autoscaling_group.this.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}
