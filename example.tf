provider "aws" {
  
profile    = "default"
region     = "us-east-1"

}

resource "aws_vpc" "terraform2" {

  cidr_block       = "10.0.0.0/16"

  
tags = {
    Name = "terraformWork"
  }

}

resource "aws_subnet" "public_subnet" {
  
vpc_id     = "${aws_vpc.terraform2.id}"
cidr_block = "10.0.1.0/24"
tags = {
    Name = "terraformWork"
  }

}

resource "aws_subnet" "private_subnet" {
vpc_id     = "${aws_vpc.terraform2.id}"
cidr_block = "10.0.1.0/24"
  
tags = {
    Name = "terraformWork"
  }

}

resource "aws_instance" "example" {
  
ami           = "ami-b374d5a5"
instance_type = "t2.micro"
subnet_id = "${aws_subnet.private_subnet.id}"

}

