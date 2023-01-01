# Create VPC
resource "aws_vpc" "ca-vpc" {
 cidr_block = "10.0.0.0/16"
 
 tags = {
   Name = "ca-VPC"
 }
}

#public subnet ap-south-1a
resource "aws_subnet" "public-subnet-1a" {
  vpc_id     = "${aws_vpc.ca-vpc.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true

  }

#public subnet  ap-south-1b
resource "aws_subnet" "public-subnet-1b" {
  vpc_id     = "${aws_vpc.ca-vpc.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true

}

#private subnet ap-south-1a
resource "aws_subnet" "private-subnet-1a" {
  vpc_id     = "${aws_vpc.ca-vpc.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-south-1a"

}

#private subnet ap-south-1b
resource "aws_subnet" "private-subnet-1b" {
  vpc_id     = "${aws_vpc.ca-vpc.id}"
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-south-1b"

}

# Create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.ca-vpc.id}"

  tags = {
    Name = "igw"
  }
}

# route table for public subnet
resource "aws_route_table" "routetablePublic" {
  vpc_id = "${aws_vpc.ca-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
}

#route tabe to public subnet 
resource "aws_route_table_association" "associate" {
  subnet_id      = "${aws_subnet.public-subnet-1a.id}"
  route_table_id = "${aws_route_table.routetablePublic.id}"
}

#NAT Gateway
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = "${aws_eip.ip.id}"
  subnet_id     = "${aws_subnet.public-subnet-1a.id}"

  tags = {
    Name = "nat-gateway"
  }
}

#route table for private subnet
resource "aws_route_table" "ca-rt" {
  vpc_id = "${aws_vpc.ca-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat-gw.id}"
  }

}

#route table to private subnet
 resource "aws_route_table_association" "associate2" {
  subnet_id      = aws_subnet.private-subnet-1a.id
  route_table_id = aws_route_table.routeTablePvt.id
}