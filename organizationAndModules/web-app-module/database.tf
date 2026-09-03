resource "aws_db_instance" "db_instance" {
    allocated_storage = 20
    storage_type = "standard"
    engine = "postgress"
    engine_version = "12"
    instance_class = "db.t3.micro"
    db_name = var.database_name
    username = var.database_user
    password = var.database_password
    skip_final_snapshot = true
}