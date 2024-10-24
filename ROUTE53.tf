# Criação da Zona Privada no Route 53
resource "aws_route53_zone" "private_zone" {
  name = "rogerio-lab.internal" # Defina o domínio da zona privada
  vpc {
    vpc_id = aws_vpc.VPC-Lab-PRD.id # Associar a VPC já criada
  }
  comment = "Zona Privada para minha VPC"
  tags = {
    Name = "Zona Privada Lab"
  }
}