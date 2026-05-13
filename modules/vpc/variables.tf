variable "vpc_name" {
  type = string
}

variable "subnet_lists" {
  type = map(object({
    cidr   = string
    region = string
    public = bool
  }))
}

variable "internet_gateway_name" {
  type = string
}

variable "route_table_name" {
  type = string
}