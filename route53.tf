resource "aws_route53_zone" "resume_website" {
  name = "davidoconnor.me"
}

resource "aws_route53_record" "resume_website" {
  zone_id = aws_route53_zone.resume_website.zone_id
  name    = "davidoconnor.me"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "resume_website" {
  provider                 = aws.us-east-1
  customer_master_key_spec = "ECC_NIST_P256"
  deletion_window_in_days  = 7
  key_usage                = "SIGN_VERIFY"
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "kms:DescribeKey",
          "kms:GetPublicKey",
          "kms:Sign",
          "kms:Verify",
        ],
        Effect = "Allow"
        Principal = {
          Service = "dnssec-route53.amazonaws.com"
        }
        Sid      = "Allow Route 53 DNSSEC Service",
        Resource = "*"
      },
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Resource = "*"
        Sid      = "Enable IAM User Permissions"
      },
    ]
    Version = "2012-10-17"
  })
}

# Follow the AWS "Disabling DNSSEC signing" guide before deleting  
resource "aws_route53_key_signing_key" "resume_website" {
  hosted_zone_id             = aws_route53_zone.resume_website.id
  key_management_service_arn = aws_kms_key.resume_website.arn
  name                       = "example"
}

resource "aws_route53_hosted_zone_dnssec" "resume_website" {
  depends_on = [
    aws_route53_key_signing_key.resume_website
  ]
  hosted_zone_id = aws_route53_key_signing_key.resume_website.hosted_zone_id
}