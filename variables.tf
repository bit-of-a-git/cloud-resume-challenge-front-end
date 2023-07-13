variable "domain_name" {
  description = "The domain name for my Cloud Resume Challenge website."
  type        = string
  default     = "davidoconnor.me"
}

variable "origin_id_name" {
  description = "Name of the Cloudfront Origin ID"
  type        = string
  default     = "MyS3Resume"
}