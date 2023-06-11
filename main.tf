terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "terraform-front-end-state"
    key    = "global/s3/terraform.tfstate"
    region = "eu-west-1"

    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  # This is the default
  region  = "eu-west-1"
}

provider "aws" {
  # This is to allow the creation of the ACM in us-east-1
  region = "us-east-1"
  alias = "us-east-1"
}