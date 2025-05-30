variable "cidr_block" {
  #default = "10.0.0.0/0"
}

variable "enable_dns_hostnames" {
  default = true
}

variable "enable_dns_support" {
  default = true
}

variable "common_tags" {
  default = {} # this means tags is optional
  type    = map(any)
}

variable "vpc_tags" {
  default = {} # this means tags is optional
  type    = map(any)
}

variable "igw_tags" {
  default = {}
}

variable "public_subnet_cidr" {

}

variable "public_subnet_names" {

}

variable "azs" {

}

variable "private_subnet_cidr" {

}

variable "private_subnet_names" {

}

variable "public_route_table_tags" {
  default = {}
}

variable "private_route_table_tags" {

}


