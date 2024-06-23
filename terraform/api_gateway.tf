resource "aws_api_gateway_rest_api" "data_challenge_api" {
  name        = "data_challenge_api"
  description = "API REST for Data Challenge"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

#root
# resource "aws_api_gateway_resource" "data_challenge" {
#   rest_api_id = aws_api_gateway_rest_api.data_challenge_api.id
#   parent_id   = aws_api_gateway_rest_api.data_challenge_api.root_resource_id
#   path_part   = "data_challenge"
# }
#/data_challenge/load_data
#Resource
resource "aws_api_gateway_resource" "load_data" {
  rest_api_id = aws_api_gateway_rest_api.data_challenge_api.id
  parent_id   = aws_api_gateway_rest_api.data_challenge_api.root_resource_id
  path_part   = "load_data"
}
#Method
resource "aws_api_gateway_method" "load_data" {
  rest_api_id   = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id   = aws_api_gateway_resource.load_data.id
  http_method   = "PUT"
  authorization = "NONE"
}
##Integration
resource "aws_api_gateway_integration" "load_data" {
  rest_api_id             = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id             = aws_api_gateway_resource.load_data.id
  http_method             = aws_api_gateway_method.load_data.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.lambda_data_challenge.invoke_arn
  
}

#Method Response
resource "aws_api_gateway_method_response" "load_data" {
  rest_api_id = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id = aws_api_gateway_resource.load_data.id
  http_method = aws_api_gateway_method.load_data.http_method
  status_code = "200"
}
#Integration Response
resource "aws_api_gateway_integration_response" "load_data" {
  rest_api_id = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id = aws_api_gateway_resource.load_data.id
  http_method = aws_api_gateway_method.load_data.http_method
  status_code = aws_api_gateway_method_response.load_data.status_code

  depends_on = [
    aws_api_gateway_method.load_data,
    aws_api_gateway_integration.load_data
  ]
}
#Allow API Gateway Trigger lampda to that method
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_data_challenge.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "${aws_api_gateway_rest_api.data_challenge_api.execution_arn}/*/*/*"
#   source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.data_challenge_api.id}/*/${aws_api_gateway_method.load_data.http_method}${aws_api_gateway_resource.load_data.path}"
}

resource "aws_api_gateway_deployment" "deploymnet" {
  depends_on = [
    aws_api_gateway_integration.load_data,
  ]
  lifecycle {
    create_before_destroy = true
  }
  rest_api_id = aws_api_gateway_rest_api.data_challenge_api.id
}


resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.deploymnet.id
  rest_api_id   = aws_api_gateway_rest_api.data_challenge_api.id
  stage_name    = "dev"
  
}

resource "aws_cloudwatch_log_group" "api-gw-lg"{ 
    name = "/aws/api-gw/${aws_api_gateway_rest_api.data_challenge_api.name}"
    retention_in_days = 5
}


output "function_url"{
    value = aws_api_gateway_stage.dev.invoke_url
}

