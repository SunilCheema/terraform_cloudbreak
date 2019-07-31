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

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.terraform2.id}"

  tags = {
    Name = "main"
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
cidr_block = "10.0.2.0/24"
  
tags = {
    Name = "terraformWork"
  }

}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags = {
    Name = "terraformWork"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = "${aws_egress_only_internet_gateway.foo.id}"
  }

  tags = {
    Name = "main"
  }
}

resource "aws_instance" "example" {
  
ami           = "ami-b374d5a5"
instance_type = "t2.micro"
subnet_id = "${aws_subnet.private_subnet.id}"

}

