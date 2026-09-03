#General variable
variable "region" {
    description = "Default region for provider"
    type = string
    default = "ap-southeast-1"
}

variable "app_name" {
    description = "Name of the web application"
    type = string
    default = "web-app"
}

variable "environment_name" {
    description = "deployment environment (dev/staging/production)"
    type = string
    default = "dev"
}

#EC2 variables
variable "ami" {
  description = "Amazon Machine Image to use for EC2 instances"
  type = string
  default = "ami-0532913178263be11"
}

variable "instance_type" {
    description = "EC2 instance type"
    type = string
    default = "t3.micro"
}

#s3 variables
variable "bucket_prefix" {
    description = "prefix of s3b bucket for app data"
    type = string
}

#Route 53 variable (DNS)
variable "create_dns_zone" {
    description = "if true, create new route53 zone, if false read existing rout53 zone"
    type = bool
    default = false
}

variable "domain" {
    description = "domain for website"
    type = string
}

#Database variable
variable "database_name" {
    description = "name of database"
    type = string
}

variable "database_user" {
    description = "user name for database"
    type = string
}

variable "database_password" {
    description = "password for database"
    type = string
    sensitive = true
}