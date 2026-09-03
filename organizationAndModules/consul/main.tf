terraform {
  backend "s3" {
    bucket = "molina-ts-state"
    key = "organizationAndModules/consul/terraform.tfstate"
    region = "ap-southeast-1"
    dynamodb_table = "terraform-state-locking"
    encrypt = true
  }

    required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>6.0"
        }
    }
}

provider "aws" {
  region = "ap-southeast-1"
}

#https://github.com/hashicorp/consul
module "consul" {
  source = "git::ssh://git@github.com/hashicorp/consul.git"
}