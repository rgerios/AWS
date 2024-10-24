resource "aws_security_group" "SecGroup_RDS" {
  name        = "rds-postgres-sg"
  description = "Security group for RDS instance"
  vpc_id      = "vpc-0a4bb835fe8ed9516" # Substitua pelo ID da sua VPC


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


