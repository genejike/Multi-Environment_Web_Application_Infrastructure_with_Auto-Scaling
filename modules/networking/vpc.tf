resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    { Name = "${var.tags["Environment"]}-vpc" }
  )
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Internet Gateway



# Public Subnets
resource "aws_subnet" "public" {
  for_each = { for idx, cidr in var.public_subnet_cidrs : idx => cidr }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[tonumber(each.key)]

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Environment"]}-public-${each.key}"
      Tier = "public"
    }
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  for_each = { for idx, cidr in var.private_subnet_cidrs : idx => cidr }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = data.aws_availability_zones.available.names[tonumber(each.key)]

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Environment"]}-private-${each.key}"
      Tier = "private"
    }
  )
}
# Elastic IPs for NAT (per AZ if enabled)
resource "aws_eip" "nat" {
  count = var.enable_nat_per_az ? length(var.private_subnet_cidrs) : 1
  domain = "vpc"

  tags = merge(
    var.tags,
    { Name = "${var.tags["Environment"]}-nat-eip-${count.index}" }
  )
}

