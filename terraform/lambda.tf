resource "aws_lambda_function" "lambda_data_challenge" {
  function_name = "lambda_data_challenge"
  description   = "Lambra triggered by api gateway for Globant code challenge"
  # runtime                        = "python3.12"
  role                           = aws_iam_role.lambda_exec.arn
  architectures                  = ["x86_64"]
  package_type                   = "Image"
  reserved_concurrent_executions = 1
  image_uri                      = "975691492030.dkr.ecr.us-east-1.amazonaws.com/lambda_data_challenge_repo:latest"
  memory_size                    = 256
  timeout                        = 40    
  # handler                        = "lambda_data_challenge.lambda_handler"
  vpc_config {
    ipv6_allowed_for_dual_stack = false
    security_group_ids          = [aws_security_group.rds_sg.id]
    subnet_ids                  = [aws_subnet.private_subnet_b.id, aws_subnet.private_subnet_a.id]

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

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  description = "Policy for Lambda functions"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.data_challenge_bucket.bucket}/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeNetworkInterfaces",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeInstances",
          "ec2:AttachNetworkInterface"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
resource "aws_iam_role_policy_attachment" "lambda_vpc_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
resource "aws_cloudwatch_log_group" "lambda_data_challenge_log" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_data_challenge.function_name}"
  retention_in_days = 5
}