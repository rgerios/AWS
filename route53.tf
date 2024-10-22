# Criação da Zona Privada no Route 53
resource "aws_route53_zone" "private_zone" {
  name = ""  # Defina o domínio da zona privada
  vpc {
    vpc_id = aws_vpc.vpc-0781470973184489f  # Associar a VPC já criada
  }
  comment = "Zona Privada para minha VPC"
  tags = {
    Name = "private-zone"
  }
}
