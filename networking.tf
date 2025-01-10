resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = var.public_subnet_cidr_1
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1a"
  tags = {
    Name = "mlflow-public-subnet-1-eu-west-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = var.public_subnet_cidr_2
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1b"
  tags = {
    Name = "mlflow-public-subnet-2-eu-west-1"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "mlflow-public-rt-eu-west-1"
  }
}

resource "aws_route_table_association" "public_subnet_association_1" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1.id
}

resource "aws_route_table_association" "public_subnet_association_2" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_2.id
}

resource "aws_route" "default_route_public" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.aws_internet_gateway.default_igw.id
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = var.private_subnet_cidr_1
  map_public_ip_on_launch = false
  availability_zone       = "eu-west-1a"
  tags = {
    Name = "mlflow-private-subnet-1-eu-west-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = var.private_subnet_cidr_2
  map_public_ip_on_launch = false
  availability_zone       = "eu-west-1b"
  tags = {
    Name = "mlflow-private-subnet-2-eu-west-1"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = data.aws_vpc.default.id
  tags = {
    Name = "mlflow-private-rt-eu-west-1"
  }
}

resource "aws_route_table_association" "private_subnet_association_1" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet_1.id
}

resource "aws_route_table_association" "private_subnet_association_2" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet_2.id
}