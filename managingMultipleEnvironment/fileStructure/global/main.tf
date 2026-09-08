terraform {
  backend "s3" {
    bucket = "molina-ts-state"  
    key = "managingMultipleEnvironment/global/terraform.tfstate"
    region = "ap-southeast-1"
    dynamodb_table =  "terraform-state-locking"
    encrypt = true  
  }

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_route53_zone" "primary" {
  name = "sendiko.dev"
}