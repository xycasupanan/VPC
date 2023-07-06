
#Instance creation 

resource "aws_instance" "ServerX" {
    ami           = "ami-0f74c08b8b5effa56"
    instance_type = "t2.micro"

#VPC Subnet     
    subnet_id     = aws_subnet.XY-private-a.id


}