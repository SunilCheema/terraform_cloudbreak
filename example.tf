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
  vpc_id = "${aws_vpc.terraform2.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "terraformWork"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.terraform2.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.natGateway.id}"
  }

  tags = {
    Name = "terraformWork"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "b" {
  subnet_id      = "${aws_subnet.private_subnet.id}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_eip" "lb" {
  vpc      = true
}

resource "aws_nat_gateway" "natGateway" {
  allocation_id = "${aws_eip.lb.id}"
  subnet_id     = "${aws_subnet.public_subnet.id}"
}

resource "aws_instance" "example" {
  
ami           = "ami-b374d5a5"
instance_type = "t2.micro"
subnet_id = "${aws_subnet.private_subnet.id}"

}

