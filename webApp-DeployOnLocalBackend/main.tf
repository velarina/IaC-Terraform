terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
}

provider "aws" {
    region = "ap-southeast-1"
}

resource "aws_instance" "example" {
  ami                         = "ami-0532913178263be11"
  instance_type               = "t3.micro"
}