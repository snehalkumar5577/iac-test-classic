terraform {
  required_version = "1.1.9"

  required_providers {
    aws = ">= 3.72.0, < 4"
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = var.tags
  }
}
