output "vpc_id" {
  value = aws_vpc.this.id
}

# CHANGE: export map(name => id)
output "public_subnet_ids" {
  value = { for k, s in aws_subnet.public : k => s.id }
}

output "public_rt_id" {
  value = aws_route_table.public.id
}

output "igw_id" {
  value = aws_internet_gateway.this.id
}