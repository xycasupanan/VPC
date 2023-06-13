#VPC 
resource "aws_vpc" "XY_VPC" {
    cidr_block = "192.168.0.0/24"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_classiclink = "false"
    tags {
        Name = "XY_VPC"
    }

}

#subnets 

resource "aws_subnet" "XY_public-1" {
    vpc_id = "${aws_vpc.XY_VPC}"
    cidr_block = "192.168.0.0/28"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-southeast-1a"
    tags = {
        Name = "XY_public-1"
    }
  
}

resource "aws_subnet" "XY_public-2" {
    vpc_id = "${aws_vpc.XY_VPC}"
    cidr_block = "192.168.0.0/28"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-southeast-1a"
    tags = {
        Name = "XY_public-2"
    }
  
}

resource "aws_subnet" "XY_private-1" {
    vpc_id = "${aws_vpc.XY_VPC}"
    cidr_block = "192.168.0.0/28"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-southeast-1a"
    tags = {
        Name = "XY_private-1"
    }
  
}

resource "aws_subnet" "XY_private-2" {
    vpc_id = "${aws_vpc.XY_VPC}"
    cidr_block = "192.168.0.0/28"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-southeast-1a"
    tags = {
        Name = "XY_private-2"
    }
  
}

resource "aws_internet_gateway" "XY_gw" {
    vpc_id = "${aws_vpc.XY_VPC}"
    tags = {
        Name = "XY_gw"
    }
  
}

#route tables
resource "aws_route_table" "XY_public_route" {
    vpc_id = "${aws_vpc.XY_VPC}"
    route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.XY_gw.id}"
    }
    tags = { 
        Name = "XY_public_route"
    }
}

#route associations public
resource "aws_route_table_association" "XY_route_table-a" {
    subnet_id = "${aws_subnet.XY_public-1.id}"
    route_table_id = "${aws_route_table.XY_public_route.id}" 
}

resource "aws_route_table_association" "XY_route_table-b" {
    subnet_id = "${aws_subnet.XY_public-2.id}"
    route_table_id = "${aws_route_table.XY_public_route.id}"
}

#Nat GW
resource "aws_eip" "Nat-A" {
    vpc = "true"
  
}

resource "aws_eip" "Nat-B" {
    vpc = "true"
  
}

resource "aws_nat_gateway" "XY_nat_gateway-A" {
    allocation_id = "${aws_eip.Nat-A.id}"
    subnet_id = "${aws_subnet.XY_public-1.id}"
    depends_on = ["aws_internet_gateway.XY_gw.id"] 

}

resource "aws_nat_gateway" "XY_nat_gateway-B" {
    allocation_id = "${aws.eip.Nat-B.id}"
    subnet_id = "${aws_subnet.XYpublic-2.id}"
    depends_on = [ "aws_internet.gateway.XY_gw.id" ]
    
}

#VPC setup for NAT
resource "aws_route_table" "XY_nat_route-A" {
    vpc_id = "${aws_vpc.XY_VPC.id}"
    route = {
        cidr_block = "0.0.0.0/0"
        aws_nat_gateway_id = "${aws_nat_gateway.XY_nat_gateway-A}"

    }
    tags = "XY_nat_gateway-A"
}

resource "aws_route_table" "XY_nat_route-B" {
    vpc_id = "${aws_vpc.XY_VPC.id}"
    route = {
        cidr_block = "0.0.0.0/0"
        aws_nat_gateway_id = "${aws_nat_gateway.XY_nat_gateway-B}"
    }
    tags = "XY_nat_gateway-B"
}

resource "aws_route_table_association" "XY_route_association-A" {
    subnet_id = "${aws_subnet.XY_private-1.id}"
    route_table_id = "${aws_route_table.XY_public_route.id}"
  
}

resource "aws_route_table_association" "XY_route_association-B" {
    subnet_id = "${aws_subnet.XY_private-2.id}"
    route_table_id = "${aws_route.table.XY_public_route.id}"
}