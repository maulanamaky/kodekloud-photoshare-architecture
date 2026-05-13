// -- Lambda Function
variable "function_name" {
  type = string
}

variable "lambda_iam_role" {
  type = string
}

variable "handler" {
  type = string
}

variable "filename" {
  type = string
}

variable "source_code_hash" {
  type = string
}

variable "runtime" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "lb_dns_name" {
  type = string
}

// --- Lambda Permission
variable "bucket_arn" {
  type = string
}

// --- S3 Notification 
variable "bucket_id" {
  type = string
}