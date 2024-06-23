resource "aws_api_gateway_rest_api" "data_challenge_api" {
  name        = "data_challenge_api"
  description = "API REST for Data Challenge"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

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
  type                    = "AWS_PROXY"
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
#################################create backup##########################
resource "aws_api_gateway_resource" "create_backup" {
  rest_api_id = aws_api_gateway_rest_api.data_challenge_api.id
  parent_id   = aws_api_gateway_rest_api.data_challenge_api.root_resource_id
  path_part   = "create_backup"
}
#Method
resource "aws_api_gateway_method" "create_backup" {
  rest_api_id   = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id   = aws_api_gateway_resource.create_backup.id
  http_method   = "PUT"
  authorization = "NONE"
}
##Integration
resource "aws_api_gateway_integration" "create_backup" {
  rest_api_id             = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id             = aws_api_gateway_resource.create_backup.id
  http_method             = aws_api_gateway_method.create_backup.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_data_challenge.invoke_arn

}

#Method Response
resource "aws_api_gateway_method_response" "create_backup" {
  rest_api_id = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id = aws_api_gateway_resource.create_backup.id
  http_method = aws_api_gateway_method.create_backup.http_method
  status_code = "200"
}
#Integration Response
resource "aws_api_gateway_integration_response" "create_backup" {
  rest_api_id = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id = aws_api_gateway_resource.create_backup.id
  http_method = aws_api_gateway_method.create_backup.http_method
  status_code = aws_api_gateway_method_response.create_backup.status_code

  depends_on = [
    aws_api_gateway_method.create_backup,
    aws_api_gateway_integration.create_backup
  ]
}
#######################################restore_backup##########################

resource "aws_api_gateway_resource" "restore_backup" {
  rest_api_id = aws_api_gateway_rest_api.data_challenge_api.id
  parent_id   = aws_api_gateway_rest_api.data_challenge_api.root_resource_id
  path_part   = "restore_backup"
}
#Method
resource "aws_api_gateway_method" "restore_backup" {
  rest_api_id   = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id   = aws_api_gateway_resource.restore_backup.id
  http_method   = "PUT"
  authorization = "NONE"
}
##Integration
resource "aws_api_gateway_integration" "restore_backup" {
  rest_api_id             = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id             = aws_api_gateway_resource.restore_backup.id
  http_method             = aws_api_gateway_method.restore_backup.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_data_challenge.invoke_arn

}

#Method Response
resource "aws_api_gateway_method_response" "restore_backup" {
  rest_api_id = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id = aws_api_gateway_resource.restore_backup.id
  http_method = aws_api_gateway_method.restore_backup.http_method
  status_code = "200"
}
#Integration Response
resource "aws_api_gateway_integration_response" "restore_backup" {
  rest_api_id = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id = aws_api_gateway_resource.restore_backup.id
  http_method = aws_api_gateway_method.restore_backup.http_method
  status_code = aws_api_gateway_method_response.restore_backup.status_code

  depends_on = [
    aws_api_gateway_method.restore_backup,
    aws_api_gateway_integration.restore_backup
  ]
}

#############################POST#############################333
resource "aws_api_gateway_resource" "jobs" {
  rest_api_id = aws_api_gateway_rest_api.data_challenge_api.id
  parent_id   = aws_api_gateway_rest_api.data_challenge_api.root_resource_id
  path_part   = "jobs"
}
#Method
resource "aws_api_gateway_method" "jobs" {
  rest_api_id   = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id   = aws_api_gateway_resource.jobs.id
  http_method   = "POST"
  authorization = "NONE"
}
##Integration
resource "aws_api_gateway_integration" "jobs" {
  rest_api_id             = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id             = aws_api_gateway_resource.jobs.id
  http_method             = aws_api_gateway_method.jobs.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_data_challenge.invoke_arn

}

#Method Response
resource "aws_api_gateway_method_response" "jobs" {
  rest_api_id = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id = aws_api_gateway_resource.jobs.id
  http_method = aws_api_gateway_method.jobs.http_method
  status_code = "200"
}
#Integration Response
resource "aws_api_gateway_integration_response" "jobs" {
  rest_api_id = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id = aws_api_gateway_resource.jobs.id
  http_method = aws_api_gateway_method.jobs.http_method
  status_code = aws_api_gateway_method_response.jobs.status_code

  depends_on = [
    aws_api_gateway_method.jobs,
    aws_api_gateway_integration.jobs
  ]
}

############################departments#################

resource "aws_api_gateway_resource" "departments" {
  rest_api_id = aws_api_gateway_rest_api.data_challenge_api.id
  parent_id   = aws_api_gateway_rest_api.data_challenge_api.root_resource_id
  path_part   = "departments"
}
#Method
resource "aws_api_gateway_method" "departments" {
  rest_api_id   = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id   = aws_api_gateway_resource.departments.id
  http_method   = "POST"
  authorization = "NONE"
}
##Integration
resource "aws_api_gateway_integration" "departments" {
  rest_api_id             = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id             = aws_api_gateway_resource.departments.id
  http_method             = aws_api_gateway_method.departments.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_data_challenge.invoke_arn

}

#Method Response
resource "aws_api_gateway_method_response" "departments" {
  rest_api_id = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id = aws_api_gateway_resource.departments.id
  http_method = aws_api_gateway_method.departments.http_method
  status_code = "200"
}
#Integration Response
resource "aws_api_gateway_integration_response" "departments" {
  rest_api_id = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id = aws_api_gateway_resource.departments.id
  http_method = aws_api_gateway_method.departments.http_method
  status_code = aws_api_gateway_method_response.departments.status_code

  depends_on = [
    aws_api_gateway_method.departments,
    aws_api_gateway_integration.departments
  ]
}

######################hired_employees#############
resource "aws_api_gateway_resource" "hired_employees" {
  rest_api_id = aws_api_gateway_rest_api.data_challenge_api.id
  parent_id   = aws_api_gateway_rest_api.data_challenge_api.root_resource_id
  path_part   = "hired_employees"
}
#Method
resource "aws_api_gateway_method" "hired_employees" {
  rest_api_id   = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id   = aws_api_gateway_resource.hired_employees.id
  http_method   = "POST"
  authorization = "NONE"
}
##Integration
resource "aws_api_gateway_integration" "hired_employees" {
  rest_api_id             = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id             = aws_api_gateway_resource.hired_employees.id
  http_method             = aws_api_gateway_method.hired_employees.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_data_challenge.invoke_arn

}

#Method Response
resource "aws_api_gateway_method_response" "hired_employees" {
  rest_api_id = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id = aws_api_gateway_resource.hired_employees.id
  http_method = aws_api_gateway_method.hired_employees.http_method
  status_code = "200"
}
#Integration Response
resource "aws_api_gateway_integration_response" "hired_employees" {
  rest_api_id = aws_api_gateway_rest_api.data_challenge_api.id
  resource_id = aws_api_gateway_resource.hired_employees.id
  http_method = aws_api_gateway_method.hired_employees.http_method
  status_code = aws_api_gateway_method_response.hired_employees.status_code

  depends_on = [
    aws_api_gateway_method.hired_employees,
    aws_api_gateway_integration.hired_employees
  ]
}



#Allow API Gateway Trigger lampda to that method
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_data_challenge.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.data_challenge_api.execution_arn}/*/*/*"
}

resource "aws_api_gateway_deployment" "deploymnet" {
  depends_on = [
    aws_api_gateway_integration.load_data,
    aws_api_gateway_integration.create_backup,
    aws_api_gateway_integration.restore_backup,
    aws_api_gateway_integration.jobs,
    aws_api_gateway_integration.departments,
    aws_api_gateway_integration.hired_employees,
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

resource "aws_cloudwatch_log_group" "api-gw-lg" {
  name              = "/aws/api-gw/${aws_api_gateway_rest_api.data_challenge_api.name}"
  retention_in_days = 5
}


output "function_url" {
  value = aws_api_gateway_stage.dev.invoke_url
}

