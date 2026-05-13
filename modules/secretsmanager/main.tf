resource "aws_secretsmanager_secret" "photoshare_secrets" {
  name        = var.secrets_name
  description = "Database Credentials for PhotoSharing App"

  recovery_window_in_days = var.recovery_window_in_days
}

resource "aws_secretsmanager_secret_version" "photoshare_secrets_version" {
  secret_id = aws_secretsmanager_secret.photoshare_secrets.id
  secret_string = jsonencode({
    username = var.database_username
    password = var.database_password
    engine   = var.database_engine
    host     = var.database_host
    port     = var.database_port
    dbname   = var.database_name
  })
}
