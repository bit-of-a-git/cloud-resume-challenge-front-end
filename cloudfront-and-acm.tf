resource "aws_acm_certificate" "mywebsite" {
  provider          = aws.us-east-1
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.resume_bucket.bucket_regional_domain_name
    origin_id                = var.origin_id_name
    origin_access_control_id = aws_cloudfront_origin_access_control.S3-Resume.id
  }

  # this is here while the ACM is hashed
  # viewer_certificate {
  #   cloudfront_default_certificate = true
  # }

  # Unhash this when the ACM is unhashed
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.mywebsite.arn
    ssl_support_method  = "sni-only"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Unhash this when the ACM is unhashed
  aliases = [var.domain_name]

  default_cache_behavior {
    cache_policy_id            = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    allowed_methods            = ["GET", "HEAD"]
    cached_methods             = ["GET", "HEAD"]
    target_origin_id           = var.origin_id_name
    response_headers_policy_id = aws_cloudfront_response_headers_policy.security_headers_policy.id

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }
}

resource "aws_cloudfront_response_headers_policy" "security_headers_policy" {
  name = "my-security-headers-policy"
  security_headers_config {
    content_type_options {
      override = true
    }
    frame_options {
      frame_option = "DENY"
      override     = true
    }
    referrer_policy {
      referrer_policy = "same-origin"
      override        = true
    }
    xss_protection {
      mode_block = true
      protection = true
      override   = true
    }
    strict_transport_security {
      access_control_max_age_sec = "63072000"
      include_subdomains         = true
      preload                    = true
      override                   = true
    }
    content_security_policy {
      content_security_policy = "frame-ancestors 'none'; default-src 'self' https://npwq0kjga0.execute-api.eu-west-1.amazonaws.com/dev; img-src 'self'; script-src 'self'; style-src 'self' https://fonts.googleapis.com https://cdnjs.cloudflare.com; font-src 'self' https://fonts.gstatic.com https://cdnjs.cloudflare.com; object-src 'none'"
      override                = true
    }
  }
}

resource "aws_cloudfront_origin_access_control" "S3-Resume" {
  name                              = "CloudFront S3 OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_s3_bucket_policy" "allow_Cloudfront_access" {
  bucket = aws_s3_bucket.resume_bucket.id
  policy = data.aws_iam_policy_document.allow_Cloudfront_access.json
}

data "aws_iam_policy_document" "allow_Cloudfront_access" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.resume_bucket.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        "${aws_cloudfront_distribution.s3_distribution.arn}",
      ]
    }
  }
}