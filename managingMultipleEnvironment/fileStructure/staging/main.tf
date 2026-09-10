terraform {
  backend "s3" {
    bucket         = "molina-ts-state"
    key            = "managinMultipleEnvironment/fileStructure/staging/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

variable "database_password" {
  description = "database password"
  type        = string
  sensitive   = true
}

locals {
  environment_name = "staging"
}

module "web_app" {
  source = "../../../organizationAndModules/web-app-module"

  bucket_prefix     = "web-app-data-${local.environment_name}"
  domain            = "sendiko.dev"
  environment_name  = local.environment_name
  instance_type     = "t3.micro"
  create_dns_zone   = false
  database_name     = "${local.environment_name}mydb"
  database_user     = "foo"
  database_password = var.database_password
}