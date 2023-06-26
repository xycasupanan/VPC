

#Nat GW
resource "aws_eip" "Nat-a" {
    vpc = "true"

}

resource "aws_eip" "Nat-b" {
    vpc = "true"

}

resource "aws_nat_gateway" "XY-nat-gateway-a" {
    allocation_id = aws_eip.Nat-a.id
    subnet_id = aws_subnet.XY-public-a.id
    depends_on = [aws_internet_gateway.XY-GW]

}

resource "aws_nat_gateway" "XY-nat-gateway-b" {
    allocation_id = aws.eip.Nat-b.id
    subnet_id = aws_subnet.XY-public-b.id
    depends_on = [aws_internet.gateway.XY-GW]

}

#VPC setup for NAT
resource "aws_route_table" "XY-nat-route-a" {
    vpc_id = aws_vpc.XY-VPC.id
    route  {
        cidr_block = "0.0.0.0/0"
        aws_nat_gateway_id = aws_nat_gateway.XY-nat-gateway-a.id

    }
    tags = {
         Name = "XY-nat-gateway-a"
  }
}

resource "aws_route_table" "XY-nat-route-b" {
    vpc_id = aws_vpc.XY-VPC.id
    route  {
        cidr_block = "0.0.0.0/0"
        aws_nat_gateway_id = aws_nat_gateway.XY-nat-gateway-b.id

    }
    tags = {
         Name = "XY-nat-gateway-b"
  }
}

resource "aws_route_table_association" "XY-route-association-a" {
    subnet_id = aws_subnet.XY_private-a.id
    route_table_id = aws_route_table.XY-public-route.id

}

resource "aws_route_table_association" "XY-route-association-b" {
    subnet_id = aws_subnet.XY-private-b.id
    route_table_id = aws_route.table.XY-public-route.id
}

#data

data "aws" "vpc-data" {
    backend = "local"

    config = {
        path = "${/root/terraform/DEMO/demo1/vpc.tf}"
    }
}

data "local_file" "subnet-data" {
    backend = "local"

    config = {
        path = "${/root/terraform/DEMO/demo1/vpc.tf}"
    }
}

data "local_file" "route-data" {
    backend = "local"

    config = {
        path = "${/root/terraform/DEMO/demo1/vpc.tf}"
    }
}




output "vpc_id" {
    value = aws_vpc.XY-VPC
    description = "VPC id"     
}


output "subnet_id" "XY-public-a"{
    value = ws_subnet.XY-public-a.id
    description = "Subnet id"     
}

output "subnet_id" "XY-public-b"{
    value = ws_subnet.XY-public-b.id
    description = "Subnet id"     
}

output "route_table_id" {
    value = ws_subnet.XY-public-b.id
    description = "Subnet id"     
}
