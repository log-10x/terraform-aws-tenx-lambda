variable "tenx_lambda_user_supplied_tags" {
  description = "Tags supplied by the user to populate to all generated resources"
  type        = map(string)
  default     = {}
}

variable "tenx_lambda_name" {
  description = "Set the name of the lambda function, defaults to 'my-10x-lambda'"
  type        = string
  default     = "my-10x-lambda"
}

variable "tenx_lambda_description" {
  description = "Set the description of the lambda function, defaults to 'Lambda running a 10x engine'"
  type        = string
  default     = "Lambda running a 10x engine"
}

variable "tenx_lambda_image_version" {
  description = "Set the version of the docker image to use for this lambda, defaults to 'latesl'"
  type        = string
  default     = "latest"
}

variable "tenx_lambda_mem" {
  description = "Set the memory size of the lambda function, defaults to 1024mb"
  type        = number
  default     = 1024
}

variable "tenx_lambda_timeout" {
  description = "Set the timeout of the lambda function, defaults to 900 seconds"
  type        = number
  default     = 900
}

variable "tenx_lambda_logs_retention_days" {
  description = "Set the CloudWatch logs retention days policy of the lambda function, defaults to 7"
  type        = number
  default     = 7
}

variable "tenx_lambda_app" {
  description = "Set the 10x application to run by default with this lambda"
  type        = string
  default     = ""
}

variable "tenx_lambda_options" {
  description = "Set the options map to pass into the lambda each execution."
  type        = map(any)
  default     = {}
}

variable "tenx_lambda_license_key" {
  description = "Log10x account license key"
  type        = string
  sensitive   = true
  default     = "NO-LICENSE"
}

variable "tenx_lambda_log_config" {
  description = "Config file for the lambda log4j"
  type        = string
  default     = "log4j2-lambda.yaml"
}
