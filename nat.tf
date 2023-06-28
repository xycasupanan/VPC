
#data

data "terraform_remote_state" "vpc-data" {
    backend = "local"

    config = {
        path = "/root/terraform/DEMO/demo1/terraform.tfstate"
    }
}

#Nat GW
resource "aws_eip" "Nat-a" {
    vpc = "true"
}

resource "aws_eip" "Nat-b" {
    vpc = "true"
}

resource "aws_nat_gateway" "XY-nat-gateway-a" {
    allocation_id = aws_eip.Nat-a.id
    subnet_id = data.terraform_remote_state.vpc-data.outputs.subnet_id
    depends_on = [
        data.terraform_remote_state.vpc-data.outputs.internet_gateway_id
    ]

}

resource "aws_nat_gateway" "XY-nat-gateway-b" {
    allocation_id = aws_eip.Nat-b.id
    subnet_id = data.terraform_remote_state.vpc-data.outputs.subnet_id
    depends_on = [
        data.terraform_remote_state.vpc-data.outputs_id
    ]

}

#VPC setup for NAT
resource "aws_route_table" "XY-nat-route-a" {
    vpc_id = data.terraform_remote_state.vpc-data.outputs.vpc_id
    route  {
        cidr_block = "0.0.0.0/0"
        aws_nat_gateway_id = aws_nat_gateway.XY-nat-gateway-a.id
    }
    tags = {
         Name = "XY-nat-gateway-a"
  }
}

resource "aws_route_table" "XY-nat-route-b" {
    vpc_id = data.terraform_remote_state.vpc-data.outputs.vpc_id
    route  {
        cidr_block = "0.0.0.0/0"
        aws_nat_gateway_id = aws_nat_gateway.XY-nat-gateway-b.id
    }
    tags = {
         Name = "XY-nat-gateway-b"
  }
}

resource "aws_route_table_association" "XY-route-association-a" {
    subnet_id = data.terraform_remote_state.vpc-data.outputs.subnet_id
    route_table_id = data.terraform_remote_state.vpc-data.outputs.route_table_id
}

resource "aws_route_table_association" "XY-route-association-b" {
    subnet_id = data.terraform_remote_state.vpc-data.outputs.subnet_id
    route_table_id = data.terraform_remote_state.vpc-data.outputs.route_table_id
}
