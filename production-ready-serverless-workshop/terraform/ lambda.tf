module "get_index_lambda" {
  source = "terraform-aws-modules/lambda/aws"
  version = "~> 7.0"

  function_name = "${var.service_name}-get-index"
  handler       = "index.handler"
  runtime       = "nodejs20.x"

  source_path = [{
    path = "${path.module}/../functions/get-index"
  }]

  environment_variables = {
  }

  publish = true

  allowed_triggers = {
    APIGatewayGet = {
      service    = "apigateway"
      source_arn = "${aws_api_gateway_rest_api.main.execution_arn}/${var.stage_name}/GET/"
    }
  }

  cloudwatch_logs_retention_in_days = 7
}
