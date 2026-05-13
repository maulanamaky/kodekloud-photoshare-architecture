// --- ALB
variable "alb_name" {
  type = string
}

variable "load_balancer_type" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "ip_address_type" {
  type = string
}

variable "enable_deletion_protection" {
  type = bool
}

// --- Target Group
variable "targetgroup_name" {
  type = string
}

variable "targetgroup_port" {
  type = string
}

variable "targetgroup_protocol" {
  type = string
}

// --- Security Group
variable "alb_securitygroup_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

// --- ALB Target Group Attachment
variable "ec2_instance_id" {
  type = string
}