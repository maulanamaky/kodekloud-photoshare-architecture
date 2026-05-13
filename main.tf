module "vpc" {
  source = "./modules/vpc"

  vpc_name              = "photoshare-vpc"
  subnet_lists          = var.subnet_lists
  route_table_name      = "public-rt"
  internet_gateway_name = "photoshare-igw"
}

module "iam" {
  source = "./modules/iam"

  ec2_iam_role_name    = "iam_role_ec2"
  lambda_iam_role_name = "iam_role_lambda"
}

module "rds" {
  source = "./modules/rds"

  // ==> Subnet Group ===
  subnet_group_name  = "photoshare-db-group"
  private_subnet_ids = module.vpc.private_subnet_ids

  // ==> RDS ===
  identifier              = "photoshare-db"
  database_name           = "photoshare"
  engine                  = "mysql"
  engine_version          = "8.4.7"
  instance_class          = "db.t3.micro"
  port                    = 3306
  username                = var.database_username
  password                = var.database_password
  multi_az                = false
  backup_retention_period = 0
  storage_type            = "gp3"
  allocated_storage       = 20
  publicly_accessible     = false
  parameter_group_name    = "default.mysql8.4"
  skip_final_snapshot     = true
  deletion_protection     = false

  // ==> Security Group ===
  vpc_id                 = module.vpc.vpc_id
  cidr_block             = module.vpc.cidr_block
  rds_securitygroup_name = "db-sg"
}

module "secretsmanager" {
  source = "./modules/secretsmanager"

  // ==> Secret ===
  secrets_name            = "photoshare/db/credentials"
  recovery_window_in_days = 0

  // ==> Secret Version ===
  database_username = var.database_username
  database_password = var.database_password
  database_engine   = module.rds.database_engine
  database_host     = module.rds.database_address
  database_port     = module.rds.database_port
  database_name     = module.rds.database_initial
}

module "s3" {
  source = "./modules/s3"

  // ==> Bucket ===
  bucket_name   = "photoshare-assets-bucket"
  force_destroy = true

  // ==> Bucket Encryption ===
  sse_algorithm = "AES256"

  // ==> Bucket Access ===
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "alb" {
  source = "./modules/alb"

  // ==> Application LoadBalancer ===
  alb_name                   = "photoshare-alb"
  load_balancer_type         = "application"
  public_subnet_ids          = module.vpc.public_subnet_ids
  ip_address_type            = "ipv4"
  enable_deletion_protection = false

  // ==> Target Group ===
  targetgroup_name     = "photoshare-tg"
  targetgroup_port     = 8080
  targetgroup_protocol = "http"
  vpc_id               = module.vpc.vpc_id

  // ==> Security Group ===
  alb_securitygroup_name = "photoshare-sg"

  // ==> ALB Target Group Attach ===
  ec2_instance_id = module.ec2.instance_id
}

module "ec2" {
  source = "./modules/ec2"

  // ==> Instance ===
  instance_name               = "photoshare-instance"
  ami                         = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  type                        = "t3.micro"
  public_subnet_ids           = module.vpc.public_subnet_ids
  associate_public_ip_address = true
  user_data_replace_on_change = true
  user_data = templatefile("${path.module}/src/user_data.sh", {
    s3_bucket_name = module.s3.bucket_name
    sm_name        = module.secretsmanager.secrets_name
  })

  // ==> IAM ===
  ec2_iam_role = module.iam.ec2_iam_role

  // ==> Key Pair ===
  pub_key       = var.pub_key
  key_pair_name = var.key_pair_name

  // ==> Security Group ===
  ec2_securitygroup_name = "photoshare-web-sg"
  alb_securitygroup_id   = module.alb.alb_securitygroup_id
  vpc_id                 = module.vpc.vpc_id
}

data "archive_file" "photoshare_lambda_code_path" {
  type        = "zip"
  source_file = "${path.module}/../../src/index.py"
  output_path = "lambda_function_code.zip"
}

module "lambda" {
  source = "./modules/lambda"

  // ==> Lambda Function ===
  function_name    = "photoshare-metadata-extractor"
  lambda_iam_role  = module.iam.lambda_iam_role
  handler          = "index.handler"
  filename         = data.archive_file.photoshare_lambda_code_path.output_path
  source_code_hash = data.archive_file.photoshare_lambda_code_path.output_base64sha256
  runtime          = "python3.13"

  bucket_name = module.s3.bucket_name
  lb_dns_name = module.alb.alb_dns_name

  // ==> Lambda Permission ===
  bucket_arn = module.s3.bucket_arn

  // ==> S3 Notification ===
  bucket_id = module.s3.bucket_id
}

module "cloudwatch" {
  source = "./modules/cloudwatch"

  // ==> Dashboard ===
  dashboard_name       = "PhotoShare-Monitor"
  ec2_instance_id      = module.ec2.instance_id
  lambda_function_name = module.lambda.lambda_function_name

  // ==> Metric Alarm ===
  lambda_alarm_name   = "PhotoShare-Lambda-Error-Alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "This metric monitors lambda function"
}
