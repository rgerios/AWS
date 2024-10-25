resource "aws_wafv2_web_acl" "web_acl" {
  name        = "cloudfront-web-acl"
  description = "Web ACL para proteger a distribuicao do CloudFront"
  scope       = "CLOUDFRONT"
  default_action {
    allow {}
  }

  # Regra para bloquear IPs específicos
  rule {
    name     = "BlockSpecificIPs"
    priority = 1
    action {
      block {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "blockSpecificIPs"
      sampled_requests_enabled   = true
    }
    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.blocked_ips.arn
      }
    }
  }

  # Regra para proteger contra injeção de SQL
  rule {
    name     = "SQLInjectionProtection"
    priority = 2
    action {
      block {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLInjectionProtection"
      sampled_requests_enabled   = true
    }
    statement {
      sqli_match_statement {
        field_to_match {
          body {}
        }
        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }
  }

  # Regra para proteção contra XSS
  rule {
    name     = "XSSProtection"
    priority = 3
    action {
      block {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "XSSProtection"
      sampled_requests_enabled   = true
    }
    statement {
      xss_match_statement {
        field_to_match {
          body {}
        }
        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "webACL"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_ip_set" "blocked_ips" {
  name               = "blocked-ips"
  description        = "Lista de IPs bloqueados"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"

  addresses = ["192.0.2.0/24", "198.51.100.0/24"] # Substitua pelos IPs reais
}
