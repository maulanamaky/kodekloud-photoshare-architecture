// ===== SUBNET =====

resource "aws_db_subnet_group" "photoshare_subnet_group_database" {
  name       = var.subnet_group_name
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = var.subnet_group_name
  }
}

// ===== RDS =====

resource "aws_db_instance" "photoshare_database" {
  identifier     = var.identifier
  db_name        = var.database_name
  engine         = var.engine
  port           = var.port
  engine_version = var.engine_version
  instance_class = var.instance_class
  username       = var.username
  password       = var.password
  multi_az       = var.multi_az

  backup_retention_period = var.backup_retention_period
  storage_type            = var.storage_type
  allocated_storage       = var.allocated_storage

  db_subnet_group_name   = aws_db_subnet_group.photoshare_subnet_group_database.name
  vpc_security_group_ids = [aws_security_group.photoshare_rds_securitygroup.id]
  publicly_accessible    = var.publicly_accessible
  parameter_group_name   = var.parameter_group_name
  skip_final_snapshot    = var.skip_final_snapshot
  deletion_protection    = var.deletion_protection
}