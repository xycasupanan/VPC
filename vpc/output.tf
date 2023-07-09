
output "vpc_id" {
    value = aws_vpc.XY-VPC.id
    description = "VPC id"
}

output "internet_gateway_id" {
     value = aws_internet_gateway.XY-GW
     description = "Internet GW id"
}

output "subnet_public_id_a" {
     value = aws_subnet.XY-public-a.id
     description = "Public Subnet"
  
}

output "subnet_private_id_a" {
     value = aws_subnet.XY-private-a.id
     description = "Private Subnet"
  
}

output "route_table_id" {
     value = aws_route_table.XY-public-route
     description = "Public Route Table"
}


output "subnet_public_id_a" {
     value = aws_subnet.XY-public-a.id
     description = "Public Subnet"
  
}

output "subnet_public_id_a" {
     value = aws_subnet.XY-public-a.id
     description = "Public Subnet"
  
}

output "subnet_public_id_a" {
     value = aws_subnet.XY-public-a.id
     description = "Public Subnet"
  
}