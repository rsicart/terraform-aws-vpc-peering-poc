resource "aws_security_group" "allow_home_a" {
    name = "allow_home"
    description = "allow all inbound connections from my home"
    vpc_id = "${aws_vpc.vpc_a.id}"

    ingress {
	from_port = 0
	to_port = 22
	protocol = "tcp"
	cidr_blocks = [
	    "${var.my_home}"
	]
    }

    ingress {
	from_port = -1
	to_port = -1
	protocol = "icmp"
	cidr_blocks = [
	    "${var.my_home}",
	    "${var.vpc_a_cidr}",
	    "${var.vpc_b_cidr}",
	]
    }

    ingress {
	from_port = 0
	to_port = 80
	protocol = "tcp"
	cidr_blocks = [
	    "${var.my_home}",
	    "${var.vpc_a_cidr}",
	    "${var.vpc_b_cidr}",
	]
    }

    egress {
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = [
	    "0.0.0.0/0"
	]
    }
}

resource "aws_security_group" "allow_home_b" {
    name = "allow_home"
    description = "allow all inbound connections from my home"
    vpc_id = "${aws_vpc.vpc_b.id}"

    ingress {
	from_port = 0
	to_port = 22
	protocol = "tcp"
	cidr_blocks = [
	    "${var.my_home}"
	]
    }

    ingress {
	from_port = -1
	to_port = -1
	protocol = "icmp"
	cidr_blocks = [
	    "${var.my_home}",
	    "${var.vpc_a_cidr}",
	    "${var.vpc_b_cidr}",
	]
    }

    ingress {
	from_port = 0
	to_port = 80
	protocol = "tcp"
	cidr_blocks = [
	    "${var.my_home}",
	    "${var.vpc_a_cidr}",
	    "${var.vpc_b_cidr}",
	]
    }

    egress {
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = [
	    "0.0.0.0/0"
	]
    }
}
