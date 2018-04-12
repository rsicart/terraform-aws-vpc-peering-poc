variable "access_key" {}
variable "secret_key" {}

variable "peer_owner_id" {}

variable "my_home" {}

variable "region" {
    default = "eu-west-1"
}

variable "instance_type_micro" {
    default = "t2.micro"
}


#
# vpc a
#
variable "vpc_a_cidr" {
    default = "10.0.0.0/16"
}

variable "a_subnet_public_cidr" {
    default = "10.0.0.0/24"
}


#
# vpc b
#
variable "vpc_b_cidr" {
    default = "10.132.240.0/22"
}

variable "b_subnet_public_cidr" {
    default = "10.132.240.0/24"
}
