output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.training.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.training.cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  value       = aws_subnet.public[*].cidr_block
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.gw.id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}
