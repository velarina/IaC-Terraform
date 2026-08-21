output "instance_ip_address" {
    value = aws_instance.instance.private_ip
}

output "db_instance_address" {
    value = "aws_db_indatance.db_instance.address"
}