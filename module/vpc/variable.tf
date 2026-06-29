variable "vpc_cidr" {
  type = string
}
variable "public_subnet_cidrs" {
  type = list(string)
  validation {
    condition     = length(var.public_subnet_cidrs) == 3
    error_message = "Exactly 3 public subnet CIDRs are required for HA across 3 AZs."
  }
}

variable "availability_zones" {
  type = list(string)
  validation {
    condition     = length(var.availability_zones) == 3
    error_message = "Exactly 3 availability zones are required."
  }
}
variable "private_subnet_cidrs" {
  type = list(string)
  validation {
    condition     = length(var.private_subnet_cidrs) == 3
    error_message = "Exactly 3 public subnet CIDRs are required for HA across 3 AZs."
  }
}