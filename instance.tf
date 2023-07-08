
#data

data "terraform_remote_state" "xdata" {
    backend = "local"

    config = {
        path = "../network/terraform.tfstate"
   }
}


#Instance creation 

resource "aws_instance" "ServerX" {
    ami           = var.AMI
    instance_type = var.INSTANCE_TYPE

#VPC Subnet     
    subnet_id     = data.terraform_remote_state.xdata.outputs.vpc_id


}