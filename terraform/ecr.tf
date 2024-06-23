resource "aws_ecr_repository" "lambda_data_challenge_repo" {
  name                 = "lambda_data_challenge_repo"
  force_delete         = true
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
  tags = {
  Name = var.default_tag }
}

output "repository_url" {
  value = aws_ecr_repository.lambda_data_challenge_repo.repository_url
}