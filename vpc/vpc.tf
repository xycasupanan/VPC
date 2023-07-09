#VPC
resource "aws_vpc" "XY-VPC" {
    cidr_block = "192.168.0.0/24"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_classiclink = "false"
    tags = {
        Name = "ProjectX"
        Description = "For ProjectX VPC"
    }

}

#subnets

resource "aws_subnet" "XY-public-a" {
    vpc_id = aws_vpc.XY-VPC.id
    cidr_block = "192.168.0.0/28"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-southeast-1a"
    tags = {
        Name = "XY-public-a "
    }

}

resource "aws_subnet" "XY-public-b" {
    vpc_id = aws_vpc.XY-VPC.id
    cidr_block = "INPUT_VALUE"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-southeast-1a"
    tags = {
        Name = "XY-public-b"
    }

}

resource "aws_subnet" "XY-private-a" {
    vpc_id = aws_vpc.XY-VPC.id
    cidr_block = "192.168.0.32/28"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-southeast-1a"
    tags = {
        Name = "XY-private-a"
    }

}

resource "aws_subnet" "XY-private-b" {
    vpc_id = aws_vpc.XY-VPC.id
    cidr_block = "192.168.0.48/28"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-southeast-1a"
    tags = {
        Name = "XY-private-b"
    }

}

resource "aws_internet_gateway" "XY-GW" {
    vpc_id = aws_vpc.XY-VPC.id
    tags = {
        Name = "XY-GW"
    }

}

#route tables
resource "aws_route_table" "XY-public-route" {
    vpc_id = aws_vpc.XY-VPC.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.XY-GW.id
    }
    tags = {
        Name = "XY-public-route"
    }
}

#route associations public
resource "aws_route_table_association" "XY-route-table-a" {
    subnet_id = aws_subnet.XY-public-a.id
    route_table_id = aws_route_table.XY-public-route.id
}

resource "aws_route_table_association" "XY-route-table-b" {
    subnet_id = aws_subnet.XY-public-b.id
    route_table_id = aws_route_table.XY-public-route.id
}


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
