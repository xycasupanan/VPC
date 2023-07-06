
#data

#data "terraform_remote_state" "xdata" {
#    backend = "local"

#    config = {
#        path = "/root/terraform/DEMO/demo1/terraform.tfstate"
#    }
#}

#Nat GW
resource "aws_eip" "Nat-a" {
#    vpc = "true"
}

resource "aws_eip" "Nat-b" {
#    vpc = "true"
}

resource "aws_nat_gateway" "XY-nat-gateway-a" {
    allocation_id = aws_eip.Nat-a.id
    subnet_id = aws_subnet.XY-private-a.id
#    depends_on = [
#        data.terraform_remote_state.xdata.outputs.internet_gateway_id
#    ]

}

resource "aws_nat_gateway" "XY-nat-gateway-b" {
    allocation_id = aws_eip.Nat-b.id
    subnet_id = aws_subnet.XY-private-b.id
#    depends_on = [
#        data.terraform_remote_state.xdata.outputs.nternet_gateway_id
#    ]

}

#VPC setup for NAT
resource "aws_route_table" "XY-nat-route-a" {
    vpc_id = aws_vpc.XY-VPC.id
    route  {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.XY-nat-gateway-a.id
    }
    tags = {
         Name = "XY-nat-gateway-a"
  }
}

resource "aws_route_table" "XY-nat-route-b" {
    vpc_id = aws_vpc.XY-VPC.id
    route  {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.XY-nat-gateway-b.id
    }
    tags = {
         Name = "XY-nat-gateway-b"
  }
}

resource "aws_route_table_association" "XY-route-association-a" {
    subnet_id = aws_subnet.XY-private-a.id
    route_table_id = aws_route_table.XY-public-route.id
}

resource "aws_route_table_association" "XY-route-association-b" {
    subnet_id = aws_subnet.XY-private-b.id
    route_table_id = aws_route_table.XY-public-route.id
}
