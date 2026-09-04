terraform {
    
   backend "s3"{
    bucket = "vela-tryingout-terraform"
    key = "organizationAndModules/web-app/terraform.tfstate"
    region = "ap-southeast-1"
    dynamodb_table = "terraform-state-locking"
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

variable "db_password_1" {
  description = "password for database #1"
  type = string
  sensitive = true
}

variable "db_password_2" {
  description = "password for database #2"
  type = string
  sensitive = true
}

module "web_app_1" {
  source = "../web-app-module"

  #input variable
  bucket_prefix = "vela-tryingout-terraform"
  domain = "sendiko.dev"
  app_name = "web-app-1"
  environment_name = "production"
  instance_type = "t3.micro"
  create_dns_zone = true
  database_name = "webApp1Db"
  database_user = "foo"
  database_password = var.db_password_1
}

module "web_app_2" {
  source = "../web-app-module"

  #input variable
  bucket_prefix = "vela-tryingout-terraform"
  domain = "otherdomain.com"
  app_name = "web-app-2"
  environment_name = "production"
  instance_type = "t3.micro"
  create_dns_zone = true
  database_name = "webApp1Db"
  database_user = "foo"
  database_password = var.db_password_2
}