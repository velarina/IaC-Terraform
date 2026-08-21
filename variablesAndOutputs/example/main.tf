terraform {
    backend "s3" {
        bucket = "vela-tryingout-terraform"
        key = "TerraformProjectTutirial/variablesAndOutput/example/terraform.tfstate"
        region = "ap-southeast-1"
        dynamodb_table = "terraform-state-locking"
        encrypt = true
    }

    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>4"
        }
    }
}

provider "aws" {
    region = "ap-southeast-1"
}

#locals
locals {
    extra_tag = "extra-tag"
}

resource "aws_instance" "instance" {
    ami = var.ami
    instance_type = var.instance_type

    tags = {
        name = var.instance_name
        extra_tag = local.extra_tag
    }
}

resource "aws_db_instance" "db_instance" {
    allocated_storage = 20
    storage_type = "gp2"
    engine = "postgres"
    engine_version = "12.22"
    instance_class = "db.t3.micro"
    name = "mydb"
    username = var.db_user
    password = var.db_pass
    skip_final_snapshot = true
}