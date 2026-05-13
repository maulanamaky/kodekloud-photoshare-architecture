resource "aws_cloudwatch_dashboard" "photoshare_metric_dashboard" {
  dashboard_name = var.dashboard_name

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          view = "TimeSeries"
          stacked = false
          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "InstanceId",
              var.ec2_instance_id
            ]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "EC2 Instance CPU"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          view = "SingleValue"
          metrics = [
            [
              "AWS/Lambda",
              "Invocations",
              "FunctionName",
              var.lambda_function_name
            ]
          ]
          period = 300
          stat   = "Sum"
          region = "us-east-1"
          title  = "Lambda Function"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_metric_alarm" "photoshare_alarm_metric_lambda" {
  alarm_name                = var.lambda_alarm_name
  comparison_operator       = var.comparison_operator
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name
  namespace                 = var.namespace
  period                    = var.period
  statistic                 = var.statistic
  threshold                 = var.threshold
  alarm_description         = var.alarm_description
  
  dimensions = {
    FunctionName = var.lambda_function_name
  }
}