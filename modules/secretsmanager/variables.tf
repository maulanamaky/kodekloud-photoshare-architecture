// === Secrets ===
variable "secrets_name" {
  type        = string
  description = "Name of the secret"
}

variable "recovery_window_in_days" {
  type        = number
  description = "The input is number for long keep credentials"
}

// === Secret Version Database ===
variable "database_username" {
  type        = string
  description = "Database Username"
  sensitive   = true
}

variable "database_password" {
  type        = string
  description = "Database Password"
  sensitive   = true
}

variable "database_engine" {
  type        = string
  description = "The engine of the database"
}

variable "database_host" {
  type        = string
  description = "Host of the database"
}

variable "database_port" {
  type        = number
  description = "Database port"
}

variable "database_name" {
  type        = string
  description = "Name of the database"
}
