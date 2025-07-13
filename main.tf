locals {
  tags = merge(var.tenx_lambda_user_supplied_tags, {
    terraform-module         = "tenx-aws-lambda"
    terraform-module-version = "v0.1.0"
    managed-by               = "tenx-terraform"
  })

  lambda_bootstrap_args = [
    "logConfig", var.tenx_lambda_log_config
  ]
}

module "tenx_pipeline_lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "8.0.1"

  function_name = var.tenx_lambda_name
  description   = var.tenx_lambda_description

  create_package = false

  s3_existing_package = {
    bucket = "log10x-engine-lambda"
    key    = "releases/${var.tenx_lambda_image_version}/tenx-lambda.zip"
  }

  handler = "com.log10x.ext.lambda.run.RunLambda::handleRequest"
  runtime = "java21"

  cloudwatch_logs_retention_in_days = var.tenx_lambda_logs_retention_days
  timeout                           = var.tenx_lambda_timeout
  memory_size                       = var.tenx_lambda_mem

  environment_variables = {
    TENX_LICENSE           = "${var.tenx_lambda_license_key}"
    TENX_DEFAULT_APP       = "${var.tenx_lambda_app}"
    TENX_DEFUALT_BOOTSTRAP = jsonencode(local.lambda_bootstrap_args)
    TENX_DEFAULT_CONFIG    = jsonencode(var.tenx_lambda_options)
    TENX_MODULES           = "/var/task/modules"
    TENX_CONFIG            = "/var/task/config"
    JAVA_TOOL_OPTIONS      = "-Djdk.httpclient.allowRestrictedHeaders=host"
  }

  tags = local.tags
}
