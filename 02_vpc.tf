#
# vpc a
#
resource "aws_vpc" "vpc_a" {
    cidr_block = "${var.vpc_a_cidr}"
    tags {
	Name = "vpc_a"
    }
}

resource "aws_internet_gateway" "default_gw_a" {
    vpc_id = "${aws_vpc.vpc_a.id}"
}

/*
 * Public subnet
 */
resource "aws_subnet" "a_public_subnet" {
    vpc_id = "${aws_vpc.vpc_a.id}"
    cidr_block = "${var.a_subnet_public_cidr}"
    availability_zone = "${var.region}a"
}

resource "aws_route_table" "a_public_subnet_rt" {
    vpc_id = "${aws_vpc.vpc_a.id}"
    route {
	cidr_block = "0.0.0.0/0"
	gateway_id = "${aws_internet_gateway.default_gw_a.id}"
    }
    route {
	cidr_block = "${var.vpc_b_cidr}"
        vpc_peering_connection_id = "${data.aws_vpc_peering_connection.pc.id}"
    }
    tags {
	Name = "public subnet route table"
    }
}

resource "aws_route_table_association" "a_public_subnet_rt_association" {
    subnet_id = "${aws_subnet.a_public_subnet.id}"
    route_table_id = "${aws_route_table.a_public_subnet_rt.id}"
}

#
# vpc b
#
resource "aws_vpc" "vpc_b" {
    cidr_block = "${var.vpc_b_cidr}"
    tags {
	Name = "vpc_b"
    }
}

resource "aws_internet_gateway" "default_gw_b" {
    vpc_id = "${aws_vpc.vpc_b.id}"
}

/*
 * Public subnet
 */
resource "aws_subnet" "b_public_subnet" {
    vpc_id = "${aws_vpc.vpc_b.id}"
    cidr_block = "${var.b_subnet_public_cidr}"
    availability_zone = "${var.region}a"
}

resource "aws_route_table" "b_public_subnet_rt" {
    vpc_id = "${aws_vpc.vpc_b.id}"
    route {
	cidr_block = "0.0.0.0/0"
	gateway_id = "${aws_internet_gateway.default_gw_b.id}"
    }
    route {
	cidr_block = "${var.vpc_a_cidr}"
        vpc_peering_connection_id = "${data.aws_vpc_peering_connection.pc.id}"
    }
    tags {
	Name = "public subnet route table"
    }
}

resource "aws_route_table_association" "b_public_subnet_rt_association" {
    subnet_id = "${aws_subnet.b_public_subnet.id}"
    route_table_id = "${aws_route_table.b_public_subnet_rt.id}"
}

#
# vpc peering
#
resource "aws_vpc_peering_connection" "vpc_peering_a_b" {
  peer_owner_id = "${var.peer_owner_id}"
  peer_vpc_id   = "${aws_vpc.vpc_b.id}"
  vpc_id        = "${aws_vpc.vpc_a.id}"
  auto_accept   = true

  tags {
    Name = "VPC Peering between foo and bar"
  }
}

# data sources
data "aws_vpc_peering_connection" "pc" {
  vpc_id          = "${aws_vpc.vpc_a.id}"
  peer_cidr_block = "${var.vpc_b_cidr}"
}

## Create a route table from a to b
#resource "aws_route_table" "rt_peering_a" {
#  vpc_id = "${aws_vpc.vpc_a.id}"
#}
#
## Create a route
#resource "aws_route" "r_a_to_b" {
#  route_table_id            = "${aws_route_table.rt_peering_a.id}"
#  destination_cidr_block    = "${data.aws_vpc_peering_connection.pc.peer_cidr_block}"
#  destination_cidr_block    = "${var.vpc_b_cidr}"
#  vpc_peering_connection_id = "${data.aws_vpc_peering_connection.pc.id}"
#}
#
#resource "aws_route_table_association" "a_rt_association_peering" {
#    subnet_id = "${aws_subnet.a_public_subnet.id}"
#    route_table_id = "${aws_route_table.rt_peering_a.id}"
#}
#
## Create a route table
#resource "aws_route_table" "rt_peering_b" {
#  vpc_id = "${aws_vpc.vpc_b.id}"
#}
#
## Create a route
#resource "aws_route" "r_b_to_a" {
#  route_table_id            = "${aws_route_table.rt_peering_b.id}"
#  destination_cidr_block    = "${var.vpc_a_cidr}"
#  vpc_peering_connection_id = "${data.aws_vpc_peering_connection.pc.id}"
#}
#
#resource "aws_route_table_association" "b_rt_association_peering" {
#    subnet_id = "${aws_subnet.b_public_subnet.id}"
#    route_table_id = "${aws_route_table.rt_peering_b.id}"
#}
