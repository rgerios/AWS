# Criar o bucket S3 para hospedar o site estático
resource "aws_s3_bucket" "static_site" {
  bucket = "desafiolablocaliza"  

  # Configuração para o bucket servir como um site estático
  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "Site Estático"
    Environment = "Desafio"
  }
}

# Política para tornar o bucket S3 público e irrestrito
resource "aws_s3_bucket_policy" "public_access_policy" {
  bucket = aws_s3_bucket.static_site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "s3:GetObject"
        Effect    = "Allow"
        Resource  = "${aws_s3_bucket.static_site.arn}/*"
        Principal = "*"
      }
    ]
  })
}

# Permissões irrestritas para o bucket S3
resource "aws_s3_bucket_public_access_block" "no_public_access_block" {
  bucket                  = aws_s3_bucket.static_site.id
  block_public_acls        = false
  block_public_policy      = false
  ignore_public_acls       = false
  restrict_public_buckets  = false
}

# Upload dos arquivos do site
resource "aws_s3_bucket_object" "index" {
  bucket = aws_s3_bucket.static_site.bucket
  key    = "site.html"
  source = "site.html"  # O caminho local do arquivo "index.html"
  content_type = "text/html"
  #acl    = "public-read"  # Tornar o arquivo publicamente acessível
}

resource "aws_s3_bucket_object" "error" {
  bucket = aws_s3_bucket.static_site.bucket
  key    = "error.html"
  source = "error.html"  # O caminho local do arquivo "error.html"
  content_type = "text/html"
  #acl    = "public-read"  # Tornar o arquivo publicamente acessível
}

# Output para o URL do site
output "s3_website_url" {
  value = aws_s3_bucket.static_site.website_endpoint
}
