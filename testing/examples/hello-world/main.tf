terraform {
  backend "s3" {
    bucket         = "amazon-bucket-vela-terraform"
    key            = "testing/examples/hello-world/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "amazon-dynamoDb-vela-terraform"
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

module "web_app" {
  source = "../../modules/hello-world"
}

output "instance_ip_address" {
  value = module.web_app.instance_ip_address
}

output "url" {
  value = "http://${module.web_app.instance_ip_address}:8080"
}