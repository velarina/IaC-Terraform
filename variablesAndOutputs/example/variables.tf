variable "instance_name" {
    description = "Name of ec2 instance"
    type = string
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

variable "db_user" {
    description = "username for database"
    type = string
    default = "foo"
}

variable "db_pass" {
    description = "password for database"
    type = string
}