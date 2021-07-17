provider "aws" {
  region = "us-west-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  allowed_account_ids = [
    138529816634
  ]
}