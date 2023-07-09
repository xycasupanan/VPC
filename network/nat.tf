
#data

data "terraform_remote_state" "xdata" {
    backend = "local"
    config = {
        path = "./vpc/terraform.tfstate"
    }
}

data "terraform_remote_state" "ec2" {
    backend = "local"
    config = {
        path = "./resources/terraform.tfstate"
    }
}

#Nat GW
resource "aws_eip" "Nat-a" {
#    vpc = "true"
}

resource "aws_eip" "Nat-b" {
#    vpc = "true"
}

resource "aws_nat_gateway" "XY-nat-gateway-a" {
    allocation_id = aws_eip.Nat-a.id
    subnet_id = terraform_remote_state.ec2.OUTPUT_NAME
#    depends_on = [
#        data.terraform_remote_state.xdata.outputs.internet_gateway_id
#    ]

}

resource "aws_nat_gateway" "XY-nat-gateway-b" {
    allocation_id = aws_eip.Nat-b.id
    subnet_id = aws_subnet.XY-private-b.id
    depends_on = aws_nat_gateway.XY-nat-gateway-a

}

#VPC setup for NAT
resource "aws_route_table" "XY-nat-route-a" {
    vpc_id = data.terraform_remote_state.xdata.outputs.vpc_id
    route  {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.XY-nat-gateway-a.id
    }
    tags = {
         Name = "XY-nat-gateway-a"
  }
}

resource "aws_route_table" "XY-nat-route-b" {
    vpc_id = data.terraform_remote_state.xdata.outputs.vpc_id
    route  {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.XY-nat-gateway-b.id
    }
    tags = {
         Name = "XY-nat-gateway-b"
  }
}

resource "aws_route_table_association" "XY-route-association-a" {
    subnet_id = data.terraform_remote_state.xdata.outputs.subnet_id_private_a
    route_table_id = data.terraform_remote_state.xdata.outputs.route_table_id
}

resource "aws_route_table_association" "XY-route-association-b" {
    subnet_id = data.terraform_remote_state.xdata.outputs.subnet_id_private_b
    route_table_id = data.terraform_remote_state.xdata.outputs.route_table_id
}
