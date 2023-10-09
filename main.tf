// create vpc
resource "aws_vpc" "hoangla_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "hoangla_vpc"
  }
}
// craete subnet private
resource "aws_subnet" "hoangla_private_subnet_1" {
  vpc_id            = aws_vpc.hoangla_vpc.id
  cidr_block        = var.private_subnet_cidr[0]
  availability_zone = var.az[0]
  tags = {
    Name = "hoangla_private_subnet_1"
  }
}
resource "aws_subnet" "hoangla_private_subnet_2" {
  vpc_id            = aws_vpc.hoangla_vpc.id
  cidr_block        = var.private_subnet_cidr[1]
  availability_zone = var.az[1]
  tags = {
    Name = "hoangla_private_subnet_2"
  }
}
resource "aws_subnet" "hoangla_private_subnet_3" {
  vpc_id            = aws_vpc.hoangla_vpc.id
  cidr_block        = var.private_subnet_cidr[2]
  availability_zone = var.az[2]
  tags = {
    Name = "hoangla_private_subnet_3"
  }
}
// create subnet public
resource "aws_subnet" "hoangla_public_subnet_1" {
  vpc_id                  = aws_vpc.hoangla_vpc.id
  cidr_block              = var.public_subnet_cidr[0]
  availability_zone       = var.az[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "hoangla_public_subnet_1"
  }
}
resource "aws_subnet" "hoangla_public_subnet_2" {
  vpc_id                  = aws_vpc.hoangla_vpc.id
  cidr_block              = var.public_subnet_cidr[1]
  availability_zone       = var.az[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "hoangla_public_subnet_2"
  }
}
resource "aws_subnet" "hoangla_public_subnet_3" {
  vpc_id                  = aws_vpc.hoangla_vpc.id
  cidr_block              = var.public_subnet_cidr[2]
  availability_zone       = var.az[2]
  map_public_ip_on_launch = true
  tags = {
    Name = "hoangla_public_subnet_3"
  }
}
// create nat gateway
resource "aws_nat_gateway" "hoangla_nat_gw" {
  allocation_id = aws_eip.hoangla_eip.id
  subnet_id     = aws_subnet.hoangla_public_subnet_1.id
}
resource "aws_eip" "hoangla_eip" {
  domain = "vpc"
  tags = {
    Name = "hoangla_eip"
  }
}
resource "aws_internet_gateway" "hoangla_ig" {
  vpc_id = aws_vpc.hoangla_vpc.id
  tags = {
    Name = "hoangla_ig"
  }
}
resource "aws_route_table" "hoangla_rt_public" {
  vpc_id = aws_vpc.hoangla_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hoangla_ig.id
  }
  tags = {
    Name = "hoangla_rt_public"
  }
}
resource "aws_route_table_association" "hoangla_rt_ass_public_1" {
  route_table_id = aws_route_table.hoangla_rt_public.id
  subnet_id      = aws_subnet.hoangla_public_subnet_1.id
}
resource "aws_route_table_association" "hoangla_rt_ass_public_2" {
  route_table_id = aws_route_table.hoangla_rt_public.id
  subnet_id      = aws_subnet.hoangla_public_subnet_2.id
}
resource "aws_route_table_association" "hoangla_rt_ass_public_3" {
  route_table_id = aws_route_table.hoangla_rt_public.id
  subnet_id      = aws_subnet.hoangla_public_subnet_3.id
}
resource "aws_route_table" "hoangla_rt_private" {
  vpc_id = aws_vpc.hoangla_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.hoangla_nat_gw.id
  }
  tags = {
    Name = "hoangla_rt_private"
  }
}
resource "aws_route_table_association" "hoangla_rt_ass_private_1" {
  route_table_id = aws_route_table.hoangla_rt_private.id
  subnet_id      = aws_subnet.hoangla_private_subnet_1.id
}
resource "aws_route_table_association" "hoangla_rt_ass_private_2" {
  route_table_id = aws_route_table.hoangla_rt_private.id
  subnet_id      = aws_subnet.hoangla_private_subnet_2.id
}
resource "aws_route_table_association" "hoangla_rt_ass_private_3" {
  route_table_id = aws_route_table.hoangla_rt_private.id
  subnet_id      = aws_subnet.hoangla_private_subnet_3.id
}
# Security group alb
resource "aws_security_group" "hoangla_sg_alb" {
  name        = "hoangla-alb-sg"
  description = "SG for hoangla-ecs"
  vpc_id      = aws_vpc.hoangla_vpc.id
  ingress {
    description = "http"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  ingress {
    description = "Allow port 9001"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
  egress {
    description = "controll traffic outbound"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  tags = {
    Name        = "hoangla_sg_alb"
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
# SG ECS 
resource "aws_security_group" "hoangla_sg_ecs" {
  name        = "hoangla-ecs-sg"
  description = "SG for hoangla-ecs"
  vpc_id      = aws_vpc.hoangla_vpc.id
  ingress {
    description = "http"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  ingress {
    description = "Allow port 443ss"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
  ingress {
    description = "Allow ssh form 209"
    cidr_blocks = ["10.12.5.0/24"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  tags = {
    Name        = "hoangla_sg_ecs"
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
