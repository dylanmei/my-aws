terraform {
  required_version = "= 1.0.2"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.30"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.3"
    }
  }
}

variable aws_access_key {
  description = "My AWS access key ID"
  type = string
}

variable aws_secret_key {
  description = "My AWS secret access key"
  type = string
  sensitive = true
}
