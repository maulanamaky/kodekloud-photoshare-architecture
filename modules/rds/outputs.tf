output "database_address" {
  value = aws_db_instance.photoshare_database.address
}

output "database_initial" {
  value = aws_db_instance.photoshare_database.db_name
}

output "database_port" {
  value = aws_db_instance.photoshare_database.port
}

output "database_engine" {
  value = aws_db_instance.photoshare_database.engine
}
