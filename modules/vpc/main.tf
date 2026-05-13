resource "aws_vpc" "photoshare_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "photoshare_subnet" {
  for_each = var.subnet_lists

  vpc_id                  = aws_vpc.photoshare_vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.region
  map_public_ip_on_launch = each.value.public

  tags = {
    Name = each.key
  }
}

resource "aws_route_table" "photoshare_route_table" {
  vpc_id = aws_vpc.photoshare_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.photoshare_igw.id
  }

  tags = {
    Name = var.route_table_name
  }
}

resource "aws_route_table_association" "photoshare_route_table_association" {
  for_each = { for k, v in var.subnet_lists : k => v if v.public == true }

  subnet_id      = aws_subnet.photoshare_subnet[each.key].id
  route_table_id = aws_route_table.photoshare_route_table.id
}

resource "aws_internet_gateway" "photoshare_igw" {
  vpc_id = aws_vpc.photoshare_vpc.id

  tags = {
    Name = var.internet_gateway_name
  }
}