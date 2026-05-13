// === RDS ===
variable "database_name" {
  type = string
}

variable "identifier" {
  type = string
}

variable "engine" {
  type = string
}

variable "port" {
  type = number
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "storage_type" {
  type = string
}

variable "parameter_group_name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "multi_az" {
  type = bool
}

variable "backup_retention_period" {
  type = number
}

variable "publicly_accessible" {
  type = bool
}

variable "skip_final_snapshot" {
  type = bool
}

variable "deletion_protection" {
  type = bool
}

// === SUBNET GROUP ===
variable "subnet_group_name" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

// === SECURITY GROUP ===
variable "vpc_id" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "rds_securitygroup_name" {
  type = string
}