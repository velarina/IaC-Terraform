variable "region" {
    description = "Default region for provider"
    type = string
    default = "ap-southeast-1"
}

variable "ami" {
    description = "Amazon Machine Image to use for ec2 instance"
    type = string
    default = "ami-0532913178263be11"
}

variable "instance_type" {
    description = "ec2 instance type"
    type = string
    default = "t3.micro"
}

# S3 variables
variable "bucket_name" {
    description = "name of S3 bucket for app data"
    type = string
}

# route to S3 variables
varible "domain" {
    description = "domain for website"
    type = string
}

# RDS variables
variable "db_name" {
    description = "name of database"
    type = string
}

variable "db_user" {
    description = "username for database"
    type = string
}

variable "db_password" {
    description = "password for database"
    type = string
    sensitive = true
}