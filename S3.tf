resource "aws_s3_bucket" "rogerio-lab-localiza" {
  bucket = "rogerio-lab-localiza" # substitua pelo nome desejado para o bucket (nome único global)
  # acl    = "public-read"          # define o bucket como publicamente legível

  tags = {
    Name        = "rogerio-lab-localiza"
    Environment = "Desenvolvimento"
  }
}

resource "aws_s3_bucket_ownership_controls" "rogerio-lab-localiza" {
  bucket = aws_s3_bucket.rogerio-lab-localiza.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "rogerio-lab-localiza" {
  bucket = aws_s3_bucket.rogerio-lab-localiza.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "rogerio-lab-localiza" {
  depends_on = [
    aws_s3_bucket_ownership_controls.rogerio-lab-localiza,
    aws_s3_bucket_public_access_block.rogerio-lab-localiza,
  ]

  bucket = aws_s3_bucket.rogerio-lab-localiza.id
  acl    = "public-read"
}

output "bucket_name" {
  value = aws_s3_bucket.rogerio-lab-localiza.bucket
}
