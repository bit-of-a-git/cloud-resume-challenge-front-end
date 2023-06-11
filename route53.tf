# resource "aws_route53_zone" "resume_website" {
#   name = "davidoconnor.me"
# }

# resource "aws_route53_record" "resume_website" {
#   zone_id = aws_route53_zone.resume_website.zone_id
#   name    = "davidoconnor.me"
#   type    = "A"
#   alias {
#     name                   = aws_cloudfront_distribution.s3_distribution.domain_name
#     zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
#     evaluate_target_health = false
#   }
# }