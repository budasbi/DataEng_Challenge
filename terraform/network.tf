// Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.default_tag
  }
}

# Creación de un Internet Gateway
resource "aws_internet_gateway" "igw_rds" {
  vpc_id     = aws_vpc.my_vpc.id
  depends_on = [aws_vpc.my_vpc]
  tags = {
    Name = var.default_tag
  }
}

// Create a Subnet
resource "aws_subnet" "public_subnet_a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = var.default_tag
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = var.default_tag
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = var.default_tag
  }
}
resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = var.default_tag
  }
}



resource "aws_security_group" "rds_sg" {
  // Create a security group
  name_prefix = "rds-sg"

  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.default_tag
  }
}

# Creación de una tabla de rutas
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = var.default_tag
  }
}

# Asociar el Internet Gateway a la tabla de rutas
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_rds.id

}

# Asociación de la subred pública con la tabla de rutas
resource "aws_route_table_association" "public_subnet_association_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id

}

resource "aws_route_table_association" "public_subnet_association_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id

}