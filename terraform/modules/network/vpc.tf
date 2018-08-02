provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc-cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "cap-gem"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
}

#Available availability zones within the region

data "aws_availability_zones" "available" {}

# Public Subnets
resource "aws_subnet" "privates" {
  #count             = 3
  count             = "${length(data.aws_availability_zones.available.names)}"
  cidr_block        = "${cidrsubnet(var.vpc-cidr, 3, count.index)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id            = "${aws_vpc.vpc.id}"

  map_public_ip_on_launch = true

  tags {
    Name = "public-${data.aws_availability_zones.available.names[count.index]}"

    #Environment = "${var.environment}"
  }
}

resource "aws_route_table" "subnet-route-table" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "cap_gem_rt"
  }
}

resource "aws_route" "subnet-route" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
  route_table_id         = "${aws_route_table.subnet-route-table.id}"
}

resource "aws_route_table_association" "public-subnet-route-table-association" {
  count          = "${length(data.aws_availability_zones.available.names)}"
  subnet_id      = "${element(aws_subnet.privates.*.id,count.index)}"
  route_table_id = "${aws_route_table.subnet-route-table.id}"
}

/*
# Public Subnets
resource "aws_subnet" "subnet-a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.subnet-cidr-a}"
  availability_zone = "${var.region}a"
}

resource "aws_subnet" "subnet-b" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.subnet-cidr-b}"
  availability_zone = "${var.region}b"
}

resource "aws_subnet" "subnet-c" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.subnet-cidr-c}"
  availability_zone = "${var.region}c"
}

resource "aws_route_table" "subnet-route-table" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route" "subnet-route" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
  route_table_id         = "${aws_route_table.subnet-route-table.id}"
}

resource "aws_route_table_association" "subnet-a-route-table-association" {
  subnet_id      = "${aws_subnet.subnet-a.id}"
  route_table_id = "${aws_route_table.subnet-route-table.id}"
}

resource "aws_route_table_association" "subnet-b-route-table-association" {
  subnet_id      = "${aws_subnet.subnet-b.id}"
  route_table_id = "${aws_route_table.subnet-route-table.id}"
}

resource "aws_route_table_association" "subnet-c-route-table-association" {
  subnet_id      = "${aws_subnet.subnet-c.id}"
  route_table_id = "${aws_route_table.subnet-route-table.id}"
}

###########################################################
data "aws_availability_zones" "available" {}

resource "aws_subnet" "privates" {
  #count             = 3
  count             = "${length(data.aws_availability_zones.available.names)}"
  cidr_block        = "${cidrsubnet(var.vpc-cidr, 3, count.index + 1)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id            = "${aws_vpc.vpc.id}"

  map_public_ip_on_launch = true

  tags {
    Name = "public-${data.aws_availability_zones.available.names[count.index]}"

    #Environment = "${var.environment}"
  }
}

###########################################################
# Nginx
resource "aws_instance" "instance" {
  ami                         = "ami-cdbfa4ab"
  instance_type               = "t2.small"
  vpc_security_group_ids      = ["${aws_security_group.security-group.id}"]
  subnet_id                   = "${aws_subnet.subnet-a.id}"
  associate_public_ip_address = true

  user_data = <<EOF
#!/bin/sh
yum install -y nginx
service nginx start
EOF
}

resource "aws_security_group" "security-group" {
  vpc_id = "${aws_vpc.vpc.id}"

  ingress = [
    {
      from_port   = "80"
      to_port     = "80"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = "443"
      to_port     = "443"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = "22"
      to_port     = "22"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "nginx_domain" {
  value = "${aws_instance.instance.public_dns}"
}

*/

