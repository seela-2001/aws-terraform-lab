resource "aws_eip" "nat_eip_1" {
  domain = "vpc"

  tags = {
    Name = "${var.project}-nat-eip-1"
  }
}

resource "aws_eip" "nat_eip_2" {
  domain = "vpc"

  tags = {
    Name = "${var.project}-nat-eip-2"
  }
}

resource "aws_nat_gateway" "nat_gw_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "${var.project}-nat-gw-1"
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "nat_gw_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = aws_subnet.public_subnet_2.id

  tags = {
    Name = "${var.project}-nat-gw-2"
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "private_route_table_1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_1.id
  }

  tags = {
    Name = "${var.project}-private-route-table-1"
  }
}

resource "aws_route_table" "private_route_table_2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_2.id
  }

  tags = {
    Name = "${var.project}-private-route-table-2"
  }
}

resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table_1.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table_2.id
}
