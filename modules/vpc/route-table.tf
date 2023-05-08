# Route table creation and Attachment

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc-name}-public-rtb"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.vpc-name}-private-rtb"
  }
}

resource "aws_route_table_association" "public-rtb-association" {
  count = length(var.public-subnets-data)
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public-route-table.id
}

#resource "aws_route_table_association" "private-rtb-association" {
#  count = length(var.private-subnets-data)
#  subnet_id      = aws_subnet.private-subnet[count.index].id
#  route_table_id = aws_route_table.private-route-table.id
#}