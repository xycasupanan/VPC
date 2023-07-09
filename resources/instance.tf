
#Instance creation 

data "terraform_remote_state" "xdata" {
    backend = "local"
    config = {
        path = "./vpc/terraform.tfstate"
    }
}

resource "aws_instance" "ServerX" {
    ami           = "ami-0f74c08b8b5effa56"
    instance_type = "t2.micro"

#VPC Subnet     
    subnet_id     = terraform_remote_state.xdata.subnet_private_id_a


}