locals {
  cluster_name = "my-eks"
}

provider "aws" {
  region = "us-west-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  allowed_account_ids = [
    138529816634
  ]
}

data "aws_availability_zones" "available" { }

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name                   = "eks-vpc"
  cidr                   = "172.16.0.0/16"
  azs                    = slice(data.aws_availability_zones.available.names, 0 , 3)
  private_subnets        = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  public_subnets         = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
  enable_nat_gateway     = true
  single_nat_gateway     = true
  enable_dns_hostnames   = true
  one_nat_gateway_per_az = false

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host        = data.aws_eks_cluster.cluster.endpoint
  token       = data.aws_eks_cluster_auth.cluster.token
  config_path = "./kubeconfig_${local.cluster_name}"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.1.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.20"
  subnets         = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  node_groups = {
    first = {
      desired_capacity = 1
      max_capacity     = 3
      min_capacity     = 0

      instance_type = "m5.large"
    }
  }

  write_kubeconfig   = true
  kubeconfig_output_path = "./"
}
