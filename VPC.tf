# Criação da VPC
resource "aws_vpc" "VPC-Lab-PRD" {
  cidr_block       = "10.12.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "VPC-Lab-PRD"
  }
}

# Criação do Internet Gateway
resource "aws_internet_gateway" "IGW_VPC-Lab-PRD" {
  vpc_id = aws_vpc.VPC-Lab-PRD.id
  tags = {
    Name = "IGW_VPC-Lab-PRD"
  }
}

# Criação da Route Table para as Subnets Públicas
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.VPC-Lab-PRD.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW_VPC-Lab-PRD.id
  }
  tags = {
    Name = "RT-PUB"
  }
}

# Association das Subnets Públicas com a Route Table
resource "aws_route_table_association" "public_rta" {
  count          = 3
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Subnets Públicas
resource "aws_subnet" "public_subnets" {
  count = 3
  vpc_id            = aws_vpc.VPC-Lab-PRD.id
  cidr_block        = cidrsubnet(aws_vpc.VPC-Lab-PRD.cidr_block, 3, count.index)
  map_public_ip_on_launch = true
  availability_zone = element(["us-east-1a", "us-east-1b", "us-east-1c"], count.index)
  
  tags = {
    Name = "SN-PUB-${count.index + 1}"
  }
}

# Subnets Privadas
resource "aws_subnet" "private_subnets" {
  count = 3
  vpc_id            = aws_vpc.VPC-Lab-PRD.id
  cidr_block        = cidrsubnet(aws_vpc.VPC-Lab-PRD.cidr_block, 3, count.index + 3)
  availability_zone = element(["us-east-1a", "us-east-1b", "us-east-1c"], count.index)
  
  tags = {
    Name = "SN-PRIV-${count.index + 1}"
  }
}

# Criação de Tabela de Roteamento para Subnets Privadas (sem rota para a internet)
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.VPC-Lab-PRD.id
  tags = {
    Name = "RT-PRIV"
  }
}

# Association das Subnets Privadas com a Route Table Privada
resource "aws_route_table_association" "private_rta" {
  count          = 3
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

