resource "aws_kms_key" "msk" {
  description = "KMS key for MSK credentials"

  tags = {
    Name = var.cluster_name
  }
}