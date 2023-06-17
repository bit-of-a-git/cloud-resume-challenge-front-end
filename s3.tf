resource "aws_s3_bucket" "resume_bucket" {
  bucket_prefix = "my-cloud-resume-bucket-"

}


# Get rid of these if they don't work - experimenting with removing the website configuration
# resource "aws_s3_bucket_acl" "s3_bucket_acl" {
#   bucket = aws_s3_bucket.resume_bucket.id
#   acl    = "private"
# }
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.resume_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# resource "aws_s3_bucket_public_access_block" "public_read" {
#   bucket = aws_s3_bucket.resume_bucket.id

# }

# resource "aws_s3_bucket_policy" "public_read" {
#   bucket = aws_s3_bucket.resume_bucket.id
#   policy = data.aws_iam_policy_document.public_read.json
# }

# data "aws_iam_policy_document" "public_read" {
#   statement {
#     principals {
#       type        = "*"
#       identifiers = ["*"]
#     }

#     actions = [
#       "s3:GetObject",
#     ]

#     resources = [
#       "arn:aws:s3:::${aws_s3_bucket.resume_bucket.id}/*",
#     ]
#   }
# }

# resource "aws_s3_bucket_website_configuration" "simple" {
#   bucket = aws_s3_bucket.resume_bucket.id

#   index_document {
#     suffix = "index.html"
#   }
# }

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
  for_each = fileset("website/", "*")
  bucket = aws_s3_bucket.resume_bucket.id
  key = each.value
  content_type = lookup(tomap(local.mime_types), element(split(".", each.key), length(split(".", each.key)) - 1))
  source = "website/${each.value}"
  etag = filemd5("website/${each.value}")
}

resource "aws_s3_object" "assets" {
  for_each = fileset("website/assets/", "*")
  bucket = aws_s3_bucket.resume_bucket.id
  key = "assets/${each.value}"
  source = "website/assets/${each.value}"
  etag = filemd5("website/assets/${each.value}")
}