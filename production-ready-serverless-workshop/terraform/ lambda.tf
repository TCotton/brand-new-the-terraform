module "get_index_lambda" {
  source = "terraform-aws-modules/lambda/aws"
  version = "~> 7.0"

  function_name = "${var.service_name}-get-index"
  handler       = "index.handler"
  runtime       = "nodejs20.x"

  source_path = [{
    path = "${path.module}/../terraform/src/functions/get-index"
  }]

  environment_variables = {
    restaurants_api = "https://${aws_api_gateway_rest_api.main.id}.execute-api.${var.aws_region}.amazonaws.com/${var.stage_name}/restaurants"
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

module "get_restaurants_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 7.0"

  function_name = "${var.service_name}-get-restaurants"
  handler       = "index.handler"
  runtime       = "nodejs20.x"

  source_path = [{
    path = "${path.module}/../terraform/src/functions/get-restaurants"
  }]

  environment_variables = {
    default_results = "8"
    restaurants_table = module.dynamodb_restaurants_table.dynamodb_table_id
  }

  attach_policy_statements = true
  policy_statements = {
    dynamodb_read = {
      effect = "Allow"
      actions = [
        "dynamodb:Scan"
      ]
      resources = [module.dynamodb_restaurants_table.dynamodb_table_arn]
    }
  }

  publish = true

  allowed_triggers = {
    APIGatewayGet = {
      service    = "apigateway"
      source_arn = "${aws_api_gateway_rest_api.main.execution_arn}/${var.stage_name}/GET/restaurants"
    }
  }
}

