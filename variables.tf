variable "subnet_lists" {
  type = map(object({
    cidr   = string
    region = string
    public = bool
  }))
}

// === SECRETSMANAGER ===
variable "database_username" {
  type      = string
  sensitive = true
}

variable "database_password" {
  type      = string
  sensitive = true
}

// === EC2 ===
variable "key_pair_name" {
  type    = string
  default = "photoshare-key"
}

variable "pub_key" {
  type      = string
  sensitive = true
}
