# Output para Endpoint do RDS
output "rds_endpoint" {
  value       = aws_db_instance.postgres.endpoint
  description = "RDS Endpoint"
}

# Output para o URL do site
output "s3_website_url" {
  value       = aws_s3_bucket.static_site.website_endpoint
  description = "URL do Bucket"
}

# Output do endereço do CDN
output "cloudfront_url" {
  value       = aws_cloudfront_distribution.cdn.domain_name
  description = "URL do site via CloudFront"
}