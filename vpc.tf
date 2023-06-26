#VPC 
resource "aws_vpc" "XY-VPC" {
    cidr_block = "192.168.0.0/24"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_classiclink = "false"
    tags {
        Name = "XY-VPC"
    }

}

#subnets 

resource "aws_subnet" "XY-public-a" {
    vpc_id = "${aws_vpc.XY-VPC.id}"
    cidr_block = "192.168.0.0/28"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-southeast-1a"
    tags = {
        Name = "XY-public-a "
    }
  
}

resource "aws_subnet" "XY-public-b" {
    vpc_id = "${aws_vpc.XY-VPC.id}"
    cidr_block = "192.168.0.0/28"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-southeast-1a"
    tags = {
        Name = "XY-public-b"
    }
  
}

resource "aws_subnet" "XY-private-a" {
    vpc_id = "${aws_vpc.XY-VPC.id}"
    cidr_block = "192.168.0.0/28"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-southeast-1a"
    tags = {
        Name = "XY-private-a"
    }
  
}

resource "aws_subnet" "XY-private-b" {
    vpc_id = "${aws_vpc.XY-VPC.id}"
    cidr_block = "192.168.0.0/28"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-southeast-1a"
    tags = {
        Name = "XY-private-b"
    }
  
}

resource "aws_internet_gateway" "XY-GW" {
    vpc_id = "${aws_vpc.XY-VPC.id}"
    tags = {
        Name = "XY-GW"
    }
  
}

#route tables
resource "aws_route_table" "XY-public-route" {
    vpc_id = "${aws_vpc.XY-VPC.id}"
    route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.XY-GW.id}"
    }
    tags = { 
        Name = "XY-public-route"
    }
}

#route associations public
resource "aws_route_table_association" "XY-route-table-a" {
    subnet_id = "${aws_subnet.XY-public-a.id}"
    route_table_id = "${aws_route_table.XY-public-route.id}" 
}

resource "aws_route_table_association" "XY-route-table-b" {
    subnet_id = "${aws_subnet.XY-public-b.id}"
    route_table_id = "${aws_route_table.XY-public-route.id}"
}

#Nat GW
resource "aws_eip" "Nat-a" {
    vpc = "true"
  
}

resource "aws_eip" "Nat-b" {
    vpc = "true"
  
}

resource "aws_nat_gateway" "XY-nat-gateway-a" {
    allocation_id = "${aws_eip.Nat-a.id}"
    subnet_id = "${aws_subnet.XY-public-a.id}"
    depends_on = ["aws_internet_gateway.XY-GW.id"] 

}

resource "aws_nat_gateway" "XY-nat-gateway-b" {
    allocation_id = "${aws.eip.Nat-b.id}"
    subnet_id = "${aws_subnet.XY-public-b.id}"
    depends_on = [ "aws_internet.gateway.XY-GW.id" ]
    
}

#VPC setup for NAT
resource "aws_route_table" "XY-nat-route-a" {
    vpc_id = "${aws_vpc.XY-VPC.id}"
    route = {
        cidr_block = "0.0.0.0/0"
        aws_nat_gateway_id = "${aws_nat_gateway.XY-nat-gateway-a.id}"

    }
    tags = "XY-nat-gateway-a"
}

resource "aws_route_table" "XY-nat-route-b" {
    vpc_id = "${aws_vpc.XY-VPC.id}"
    route = {
        cidr_block = "0.0.0.0/0"
        aws_nat_gateway_id = "${aws_nat_gateway.XY-nat-gateway-b}"
    }
    tags = "XY-nat-gateway-b"
}

resource "aws_route_table_association" "XY-route-association-a" {
    subnet_id = "${aws_subnet.XY_private-a.id}"
    route_table_id = "${aws_route_table.XY-public-route.id}"
  
}

resource "aws_route_table_association" "XY-route-association-b" {
    subnet_id = "${aws_subnet.XY-private-a.id}"
    route_table_id = "${aws_route.table.XY-public-route.id}"
}

