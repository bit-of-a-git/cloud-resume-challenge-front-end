resource "aws_s3_bucket" "resume_bucket" {
  bucket_prefix = "my-cloud-resume-bucket-"

}

# resource "aws_s3_bucket_public_access_block" "public_read" {
#   bucket = aws_s3_bucket.resume_bucket.id

# }

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.resume_bucket.id
  policy = data.aws_iam_policy_document.public_read.json
}

data "aws_iam_policy_document" "public_read" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.resume_bucket.id}/*",
    ]
  }
}

resource "aws_s3_bucket_website_configuration" "simple" {
  bucket = aws_s3_bucket.resume_bucket.id

  index_document {
    suffix = "index.html"
  }
}

locals {
  mime_types = {
    "css"  = "text/css"
    "html" = "text/html"
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