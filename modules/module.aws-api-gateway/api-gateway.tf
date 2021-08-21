############################################
#             API Gateway REST API         #
############################################
resource "aws_api_gateway_rest_api" "portfolio_api" {
  # The name of the REST API
  name = var.rest_api_name

  description = var.api_description

  endpoint_configuration {
    types = [var.endpoint_type]
  }
}

#########################################################################
# API Gateway resource, which is a certain path inside the REST API     #
#########################################################################
resource "aws_api_gateway_resource" "portfolio_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.portfolio_api.id
  parent_id   = aws_api_gateway_rest_api.portfolio_api.root_resource_id

  path_part = var.api_gateway_reminder_path
}


######################################################
#               Enable CORS                          #
######################################################
resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.portfolio_api.id
  resource_id   = aws_api_gateway_resource.portfolio_api_resource.id
  http_method   = "OPTIONS"
  authorization = var.api_authorization
}

resource "aws_api_gateway_method_response" "options_200" {
  depends_on = [aws_api_gateway_method.options_method]

  rest_api_id   = aws_api_gateway_rest_api.portfolio_api.id
  resource_id   = aws_api_gateway_resource.portfolio_api_resource.id
  http_method   = aws_api_gateway_method.options_method.http_method
  status_code   = "200"

  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}


resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.portfolio_api.id
  resource_id = aws_api_gateway_resource.portfolio_api_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = <<EOF
      {
        "statusCode": 200
        }
    EOF

  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.portfolio_api.id
  resource_id = aws_api_gateway_resource.portfolio_api_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = aws_api_gateway_method_response.options_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}


#################################################################
# HTTP method to a API Gateway resource (REST endpoint)         #
#################################################################
resource "aws_api_gateway_method" "portfolio_api_method" {
  rest_api_id = aws_api_gateway_rest_api.portfolio_api.id
  resource_id = aws_api_gateway_resource.portfolio_api_resource.id

  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "portfolio_method_response_200" {
  depends_on = [aws_api_gateway_method.portfolio_api_method]

  rest_api_id   = aws_api_gateway_rest_api.portfolio_api.id
  resource_id   = aws_api_gateway_resource.portfolio_api_resource.id
  http_method   = aws_api_gateway_method.portfolio_api_method.http_method
  status_code   = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration" "portfolio_api_integration" {
  rest_api_id = aws_api_gateway_rest_api.portfolio_api.id
  resource_id = aws_api_gateway_resource.portfolio_api_resource.id

  http_method = aws_api_gateway_method.portfolio_api_method.http_method
  type = "AWS_PROXY"
  integration_http_method = "POST"
  uri = aws_lambda_function.email_reminder.invoke_arn
}

####################################
# API Gateway deployment           #
####################################
resource "aws_api_gateway_deployment" "portfolio_api_deployment" {
  depends_on = [aws_api_gateway_integration.portfolio_api_integration]

  rest_api_id = aws_api_gateway_rest_api.portfolio_api.id
  stage_name = var.environment
}

