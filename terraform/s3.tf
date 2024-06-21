resource "aws_s3_bucket" "data_challenge_bucket" {
  bucket = "data-challenge-bucket-oscar"
  tags = {
    Name        = var.default_tag
  }
}