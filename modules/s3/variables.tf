// === Bucket ===
variable "bucket_name" {
  type = string
}

variable "force_destroy" {
  type    = bool
  default = true
}

// === Bucket Encryption ===
variable "sse_algorithm" {
  type    = string
  default = "AES256"
}

// === Bucket Access ===
variable "block_public_acls" {
  type    = bool
  default = true
}

variable "block_public_policy" {
  type    = bool
  default = true
}

variable "ignore_public_acls" {
  type    = bool
  default = true
}

variable "restrict_public_buckets" {
  type    = bool
  default = true
}