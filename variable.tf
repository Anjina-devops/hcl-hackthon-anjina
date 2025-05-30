variable "cidr_block" {
  default = "10.0.0.0/0"
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
    type = list(string)
    default = ["10.0.10.0/24", "10.0.10.1/24"]

}

variable "public_subnet_names" {
    default = []
    type    = list(string)

}

variable "azs" {
    type = list(string)
    default = ["us-east-1a", "us-east-1b"]    

}

variable "private_subnet_cidr" {
    type = list(string)
    default = ["10.0.20.0/24", "10.0.21.1/24"]


}

variable "private_subnet_names" {
    default = []

}

variable "public_route_table_tags" {
  default = {}
}

variable "private_route_table_tags" {
    default = {}

}


