resource "aws_lambda_function" "photoshare_lambda_s3_function" {
  function_name    = var.function_name
  architectures    = ["x86_64"]
  role             = var.lambda_iam_role
  handler          = var.handler
  filename         = var.filename
  source_code_hash = var.source_code_hash
  runtime          = var.runtime

  environment {
    variables = {
      S3_BUCKET = var.bucket_name
      ALB_DNS   = var.lb_dns_name
    }
  }
}

resource "aws_lambda_permission" "photoshare_lambda_permission_allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.photoshare_lambda_s3_function.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.bucket_arn
}

resource "aws_s3_bucket_notification" "photoshare_lambda_bucket_notification" {
  bucket = var.bucket_id

  lambda_function {
    events              = ["s3:ObjectCreated:*"]
    lambda_function_arn = aws_lambda_function.photoshare_lambda_s3_function.arn
  }

  depends_on = [aws_lambda_permission.photoshare_lambda_permission_allow_s3]
}