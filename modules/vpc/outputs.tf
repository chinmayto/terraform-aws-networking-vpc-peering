output "vpc_id" {
  value = aws_vpc.app_vpc.id
}

output "public_subnets" {
  value = aws_subnet.public_subnets.*.id
}

output "public_route_table_id" {
  value = aws_route_table.public_rt.id
}
