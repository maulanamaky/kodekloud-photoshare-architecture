output "ec2_iam_role" {
  value = aws_iam_role.ec2_iam_role.name
}

output "lambda_iam_role" {
  value = aws_iam_role.lambda_iam_role.arn
}
