resource "aws_lambda_function" "lambda_data_challenge" {
  function_name                  = "lambda_data_challenge"
  description                    = "Lambra triggered by api gateway for GLobant code challenge"
  runtime                        = "python3.10"
  role                           = aws_iam_role.lambda_exec.arn
  architectures                  = ["x86_64"]
  package_type                   = "Image"
  reserved_concurrent_executions = 1
  image_uri                      = "${aws_ecr_repository.lambda_data_challenge_repo}:latest"
  memory_size                    = 128
  vpc_config {
    ipv6_allowed_for_dual_stack = false
    security_group_ids          = [aws_security_group.rds_sg.id]
    subnet_ids                  = [aws_subnet.private_subnet_b.id]

  }

  tags = {
    Name = var.default_tag
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_data_role_challenge"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_cloudwatch_log_group" "lambda_data_challenge:log"{
    name = "/aws/lambda/${aws_lambda_function.lambda_data_challenge.function_name}"
    retention_in_days = 5
}