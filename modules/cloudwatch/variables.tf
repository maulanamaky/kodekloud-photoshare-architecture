// --- Dashboard
variable "dashboard_name"{
    type = string
}

variable "ec2_instance_id"{
    type = string
}

variable "lambda_function_name"{
    type = string
}

// --- Metric Alarm
variable "lambda_alarm_name"{
    type = string
}

variable "comparison_operator"{
    type = string
}

variable "evaluation_periods"{
    type = number
}

variable "metric_name"{
    type = string
}

variable "namespace"{
    type = string
}

variable "period"{
    type = number
}

variable "statistic"{
    type = string
}

variable "threshold"{
    type = number
}

variable "alarm_description"{
    type = string
}