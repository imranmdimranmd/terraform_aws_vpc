terraform {
  required_version = ">= 0.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.30.0"
    }
  }
}
provider "aws" {
  region                   = "ap-south-1"
  shared_credentials_files = ["C:/Users/Imranm/.aws/credentials"]
  profile                  = "default"

  default_tags {
    tags = {
      created_by = "terraform"
      workspace  = terraform.workspace
    }
  }
}
