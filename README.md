# 10x AWS Lambda Terraform Module

This Terraform module simplifies the deployment of an AWS Lambda function for the 10x engine. It acts as a wrapper to deploy a pre-built function from a public S3 bucket maintained by Log10x, allowing users to configure the Lambda with custom settings such as memory, timeout, tags, and application-specific options.

## Features

- Deploys an AWS Lambda function using a pre-built 10x engine package from a public S3 bucket.
- Configurable Lambda settings including name, description, memory, timeout, and log retention.
- Supports user-defined tags for resource management.
- Allows customization of the 10x application and its runtime options.
- Integrates with AWS CloudWatch for logging.

## Prerequisites

- **Terraform**: Version >= 1.0
- **AWS Provider**: Version 6.3.0
- **AWS Credentials**: Configured with appropriate permissions to create Lambda functions, IAM roles, and CloudWatch log groups.
- **10x License Key**: A valid license key for the 10x engine.

## Usage

This module is published on Terraform Cloud and can be used directly in your Terraform configuration. Add the following to your Terraform configuration:

```hcl
module "tenx-lambda" {
  source  = "log-10x/tenx-lambda/aws"
  version = "0.2.0"
  # Insert required variables, especially tenx_lambda_license_key
}
```

## Providers

This module requires the AWS provider, configured as follows:

```hcl
provider "aws" {
  region = "us-west-2"  # or your preferred region
}
```

## Inputs

The following input variables are supported:

| Name                           | Description                                                                 | Type          | Default                         | Required |
|--------------------------------|-----------------------------------------------------------------------------|---------------|---------------------------------|----------|
| `tenx_lambda_user_supplied_tags` | Tags to apply to all generated resources                                   | `map(string)` | `{}`                            | No       |
| `tenx_lambda_name`             | Name of the Lambda function                                                | `string`      | `my-10x-lambda`                | No       |
| `tenx_lambda_description`      | Description of the Lambda function                                         | `string`      | `Lambda running a 10x engine`  | No       |
| `tenx_lambda_image_version`    | Version of the 10x Docker image to use                                    | `string`      | `latest`                       | No       |
| `tenx_lambda_mem`              | Memory size for the Lambda function (in MB)                               | `number`      | `1024`                         | No       |
| `tenx_lambda_timeout`          | Timeout for the Lambda function (in seconds)                              | `number`      | `900`                          | No       |
| `tenx_lambda_logs_retention_days` | CloudWatch logs retention period (in days)                             | `number`      | `7`                            | No       |
| `tenx_lambda_app`              | 10x application to run by default                                         | `string`      | `""`                           | No       |
| `tenx_lambda_options`          | Options map to pass to the Lambda on each execution                      | `map(any)`    | `{}`                            | No       |
| `tenx_lambda_license_key`      | 10x account license key (sensitive)                                       | `string`      | `NO-LICENSE`                   | Yes      |
| `tenx_lambda_log_config`       | Configuration file for Lambda log4j                                       | `string`      | `log4j2-lambda.yaml`           | No       |

**Important**: While all inputs have default values, `tenx_lambda_license_key` must be set to a valid 10x license key for the Lambda to function correctly. The default value (`NO-LICENSE`) is not functional.

## Outputs

The module provides the following outputs:

| Name                      | Description                                              |
|---------------------------|----------------------------------------------------------|
| `lambda_function_arn`     | The ARN of the Lambda function                           |
| `lambda_function_name`    | The name of the Lambda function                          |
| `lambda_role_arn`         | The ARN of the IAM role created for the Lambda function  |
| `lambda_role_name`        | The name of the IAM role created for the Lambda function |
| `lambda_function_invoke_arn` | The Invoke ARN of the Lambda function                  |

## Example Configuration

Below is an example of how to use this module with custom settings:

```hcl
module "tenx-lambda" {
  source  = "log-10x/tenx-lambda/aws"
  version = "0.2.0"

  tenx_lambda_name            = "my-custom-10x-lambda"
  tenx_lambda_description     = "Custom 10x Lambda for processing data"
  tenx_lambda_image_version   = "1.0.0"
  tenx_lambda_mem             = 2048
  tenx_lambda_timeout         = 600
  tenx_lambda_logs_retention_days = 14
  tenx_lambda_app             = "@apps/cloud/reporter"
  tenx_lambda_license_key     = "your-10x-license-key"

  tenx_lambda_user_supplied_tags = {
    Environment = "Production"
    Project     = "DataPipeline"
  }
}
```

## Module Details

- **Source**: The Lambda function code is sourced from a public S3 bucket (`log10x-engine-lambda`) with the key `releases/<tenx_lambda_image_version>/tenx-lambda.zip`.
- **Runtime**: The Lambda uses the `java21` runtime with the handler `com.log10x.ext.lambda.run.RunLambda::handleRequest`.
- **Tags**: User-supplied tags are merged with default tags (`terraform-module`, `terraform-module-version`, `managed-by`) for resource identification.
- **Environment Variables**: Configures the Lambda with environment variables for the 10x license key, default app, bootstrap arguments, and custom options.
- **Dependencies**: The module uses the `terraform-aws-modules/lambda/aws` module (version 8.0.1) for Lambda deployment.

## Notes

- Ensure the `tenx_lambda_license_key` is valid to avoid runtime errors.
- The S3 bucket (`log10x-engine-lambda`) is maintained by Log10x and contains pre-built Lambda packages.
- For additional details, refer to the module's page on the [Terraform Cloud Registry](https://registry.terraform.io/).
