provider "aws" {
  region  = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "kwara-bucket"
    key    = "eu-west-1/tfstate.json"
    region = "eu-west-1"
    encrypt = true
  }
}

resource "random_id" "id" {
  byte_length = 2
}
