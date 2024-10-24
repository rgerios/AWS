resource "aws_db_instance" "postgres" {
  allocated_storage      = var.allocated_storage
  engine                 = "postgres"
  #engine_version         = "13.4" # Você pode escolher a versão que preferir
  instance_class         = var.db_instance_class
  db_name                = var.db_name
  username               = var.db_user
  password               = var.db_password
  parameter_group_name   = "postgresql-parameter-group"
  skip_final_snapshot    = true                                 # Alterar para 'false' em produção para snapshots automáticos
  publicly_accessible    = false                                # Alterar se você quiser que o RDS seja acessível publicamente
  vpc_security_group_ids = [aws_security_group.SecGroup_RDS.id] # Adicionar o grupo de segurança correto
  db_subnet_group_name   = aws_db_subnet_group.SubNetGroupRDS.id
}

resource "aws_db_subnet_group" "SubNetGroupRDS" {
  name       = "subnetgrouprds"
  subnet_ids = aws_subnet.private_subnets[*].id
}

# Parameter Group para RDS PostgreSQL
resource "aws_db_parameter_group" "postgresql_param_group" {
  name        = "postgresql-parameter-group"
  family      = "postgres16"  # Altere para a versão do PostgreSQL desejada
  description = "Custom parameter group for PostgreSQL"

  parameter {
    name  = "log_min_duration_statement"
    value = "5000"  # Configuração personalizada, por exemplo: logar queries acima de 5s
  }

  parameter {
    name  = "work_mem"
    value = "65536"  # Exemplo de ajuste de memória
  }
}
