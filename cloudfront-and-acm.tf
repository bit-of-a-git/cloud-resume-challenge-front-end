# resource "aws_acm_certificate" "mywebsite" {
#   provider          = aws.us-east-1
#   domain_name       = "davidoconnor.me"
#   validation_method = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.resume_bucket.bucket_regional_domain_name
    origin_id                = "MyS3Resume"
    origin_access_control_id = aws_cloudfront_origin_access_control.S3-Resume.id

    # custom_origin_config {
    #   origin_ssl_protocols     = ["TLSv1.2"]
    #   http_port                = 80
    #   https_port               = 443
    #   origin_keepalive_timeout = 5
    #   origin_protocol_policy   = "http-only"
    # }
  }

# this is here while the ACM is hashed
  viewer_certificate {
    cloudfront_default_certificate = true
  }

# Unhash this when the ACM is unhashed
  # viewer_certificate {
  #   acm_certificate_arn = aws_acm_certificate.mywebsite.arn
  #   ssl_support_method  = "sni-only"
  # }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

# Unhash this when the ACM is unhashed
  # aliases = ["davidoconnor.me"]

  default_cache_behavior {
    cache_policy_id  = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "MyS3Resume"
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03"

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }
}

resource "aws_cloudfront_origin_access_control" "S3-Resume" {
  name                              = "CloudFront S3 OAC"
  description                       = "CloudFront S3 OAC"
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

# resource "aws_s3_bucket_policy" "b" {

#   policy = <<POLICY
# {
#   "Version": "2008-10-17",
#   "Id": "PolicyForCloudFrontPrivateContent",
#   "Statement": [
#     {
#       "Sid": "AllowCloudFrontServicePrincipal",
#       "Effect": "Allow",
#       "Principal": "cloudfront.amazonaws.com",
#       "Action": "s3:GetObject",
#       "Resource": "${aws_s3_bucket.resume_bucket.arn}/*",
#       "Condition": {
#          "StringEquals": {"AWS:SourceArn": "${aws_cloudfront_distribution.s3_distribution.arn}"}
#       }
#     }
#   ]
# }
# POLICY
# }