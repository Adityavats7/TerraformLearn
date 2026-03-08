data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  subnet_names = keys(var.public_subnets)
  chosen_azs   = length(var.azs) > 0 ? var.azs : slice(data.aws_availability_zones.available.names, 0, length(var.public_subnets))
  az_map       = { for idx, name in local.subnet_names : name => local.chosen_azs[idx] }
}

resource "aws_vpc" "this" {
  cidr_block                         = var.vpc_cidr
  enable_dns_support                 = true
  enable_dns_hostnames               = true
  assign_generated_ipv6_cidr_block   = var.enable_ipv6
  tags = merge(var.tags, { Name = "${var.tags["Project"]}-vpc" })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.tags["Project"]}-igw" })
}

# CHANGE: count -> for_each on the map
resource "aws_subnet" "public" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = local.az_map[each.key]
  map_public_ip_on_launch = true

  # Optional IPv6
  ipv6_cidr_block                 = var.enable_ipv6 ? cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, index(local.subnet_names, each.key)) : null
  assign_ipv6_address_on_creation = var.enable_ipv6

  tags = merge(var.tags, {
    Name = "${var.tags["Project"]}-${each.key}"
    Tier = "public"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.tags["Project"]}-public-rt" })
}

resource "aws_route" "to_internet_ipv4" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route" "to_internet_ipv6" {
  count                       = var.enable_ipv6 ? 1 : 0
  route_table_id              = aws_route_table.public.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}