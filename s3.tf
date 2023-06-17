resource "aws_s3_bucket" "resume_bucket" {
  bucket_prefix = "cloud-resume-bucket-"
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket                  = aws_s3_bucket.resume_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

locals {
  mime_types = {
    "css"  = "text/css"
    "html" = "text/html"
    "ico"  = "image/x-icon"
    "jpg"  = "image/jpeg/"
    "js"   = "application/javascript"
  }
}

resource "aws_s3_object" "website-files" {
  for_each     = fileset("website/", "*")
  bucket       = aws_s3_bucket.resume_bucket.id
  key          = each.value
  content_type = lookup(tomap(local.mime_types), element(split(".", each.key), length(split(".", each.key)) - 1))
  source       = "website/${each.value}"
  etag         = filemd5("website/${each.value}")
}

resource "aws_s3_object" "assets" {
  for_each = fileset("website/assets/", "*")
  bucket   = aws_s3_bucket.resume_bucket.id
  key      = "assets/${each.value}"
  source   = "website/assets/${each.value}"
  etag     = filemd5("website/assets/${each.value}")
}