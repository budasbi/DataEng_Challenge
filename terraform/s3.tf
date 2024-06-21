resource "aws_s3_bucket" "data_challenge_bucket" {
  bucket        = "data-challenge-bucket-oscar"
  force_destroy = true
  tags = {
    Name = var.default_tag
  }
}