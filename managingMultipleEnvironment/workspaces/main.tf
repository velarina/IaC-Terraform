terraform {
  backend "s3" {
    bucket = "molina-ts-state"
    key = "managingMultpleEnvironment/workspaces/terraform.tfstate"
    region = "ap-southeast-1"
    use_lockfile = true
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

variable "db_password" {
  description = "password for database"
  type = string
  sensitive = true
}

locals {
  environment_name = terraform.workspace
}

module "web_app" {
    source = "../../organizationAndModules/web-app-module"

    #input variable
    bucket_prefix = "molina-web-app-data-${local.environment_name}"
    domain = "sendiko.dev"
    environment_name = local.environment_name
    instance_type = "t3.micro"
    create_dns_zone = terraform.workspace == "production" ? true : false
    database_name = "${local.environment_name}mydb"
    database_user = "foo"
    database_password = var.db_password
}