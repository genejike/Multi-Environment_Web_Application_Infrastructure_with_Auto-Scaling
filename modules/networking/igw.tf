resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    { Name = "${var.tags["Environment"]}-igw" }
  )
}
# NAT Gateways

resource "aws_nat_gateway" "NAT" {
  count = var.enable_nat_per_az ? length(var.private_subnet_cidrs) : 1

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(values(aws_subnet.public)[*].id, count.index)

  tags = merge(
    var.tags,
    { Name = "${var.tags["Environment"]}-nat-${count.index}" }
  )

  depends_on = [aws_internet_gateway.gw]
}

# Public Route Table + Routes
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    { Name = "${var.tags["Environment"]}-public-rt" }
  )
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}
# Private Route Tables + Routes

resource "aws_route_table" "private" {
  for_each = aws_subnet.private

  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    { Name = "${var.tags["Environment"]}-private-rt-${each.key}" }
  )
}

resource "aws_route" "private_nat" {
  for_each = aws_route_table.private

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.NAT[*].id, var.enable_nat_per_az ? tonumber(each.key) : 0)
}

resource "aws_route_table_association" "private_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}
