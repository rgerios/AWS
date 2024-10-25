resource "aws_lambda_function" "lambda_rds_query" {
  filename      = "lambda_rds_query.zip" # Caminho para o arquivo zipado da Lambda
  function_name = "RDSQueryLambda"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"

  environment {
    variables = {
      RDS_HOST     = aws_db_instance.postgres.endpoint
      RDS_USER     = var.db_user
      RDS_PASSWORD = var.db_password
      RDS_DB       = var.db_name
    }
  }

  vpc_config {
    subnet_ids         = aws_subnet.public_subnets[*].id
    security_group_ids = [aws_security_group.SecGroup_Lambda.id]
  }
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  # Policy to allow Lambda to create and manage network interfaces in EC2
  inline_policy {
    name = "LambdaEC2NetworkInterfacePolicy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "ec2:CreateNetworkInterface",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface"
          ],
          Resource = "*"
        }
      ]
    })
  }
}


resource "aws_iam_role_policy" "lambda_policy" {
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "rds:DescribeDBInstances",
          "rds-db:connect"
        ],
        Effect   = "Allow",
        Resource = aws_db_instance.postgres.arn
      }
    ]
  })
}
