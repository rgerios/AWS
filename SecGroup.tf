resource "aws_security_group" "SecGroup_RDS" {
  name        = "rds-postgres-sg"
  description = "Security group for RDS instance"
  vpc_id      = aws_vpc.VPC-Lab-PRD.id # Substitua pelo ID da sua VPC


  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Altere para IPs específicos em produção
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-postgres-sg"
  }

}


resource "aws_security_group" "SecGroup_Lambda" {
  name        = "lambda-sg"
  description = "Security group for Lambda"
  vpc_id      = aws_vpc.VPC-Lab-PRD.id # Substitua pelo ID da sua VPC


  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Altere para IPs específicos em produção
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambda-sg"
  }

}