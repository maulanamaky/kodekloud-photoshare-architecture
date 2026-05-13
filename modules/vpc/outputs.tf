output "vpc_id" {
  value = aws_vpc.photoshare_vpc.id
}

output "private_subnet_ids" {
  value = [for k, v in aws_subnet.photoshare_subnet : v.id if var.subnet_lists[k].public == false]
}

output "public_subnet_ids" {
  value = [for k, v in aws_subnet.photoshare_subnet : v.id if var.subnet_lists[k].public == true]
}

output "cidr_block" {
  value = aws_vpc.photoshare_vpc.cidr_block
}