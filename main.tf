terraform {
  #specifying terraform version
  required_version = ">= 0.12.24"
  
  backend "s3" {
    bucket = "kwara-bucket"
    key    = "kwarachallenge.tfstate"
    region = "eu-west-1"
  }
}

