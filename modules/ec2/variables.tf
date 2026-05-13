// --- EC2
variable "instance_name" {
  type = string
}

variable "ami" {
  type    = string
  default = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

variable "type" {
  type    = string
  default = "t3.micro"
}

variable "associate_public_ip_address" {
  type = bool
}

variable "user_data_replace_on_change" {
  type = bool
}

variable "user_data" {
  type = string
}

// --- Key Pair
variable "key_pair_name" {
  type        = string
  description = "Name of the key EC2"
}

variable "pub_key" {
  type      = string
  default   = "Paste the public code here"
  sensitive = true
}

// -- IAM
variable "ec2_iam_role" {
  type = string
}

// --- Networking
variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

// --- Security Group
variable "ec2_securitygroup_name" {
  type = string
}

variable "alb_securitygroup_id" {
  type = string
}

