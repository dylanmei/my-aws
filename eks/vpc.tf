data aws_availability_zones "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name                   = var.cluster_name
  cidr                   = var.vpc_cidr
  azs                    = slice(data.aws_availability_zones.available.names, 0 , length(var.private_subnet_cidrs))
  private_subnets        = var.private_subnet_cidrs
  public_subnets         = var.public_subnet_cidrs
  enable_nat_gateway     = true
  single_nat_gateway     = true
  enable_dns_hostnames   = true
  one_nat_gateway_per_az = false

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

output vpc_id {
  value = module.vpc.vpc_id
}

output vpc_cidr {
  value = module.vpc.vpc_cidr_block
}

output private_subnet_ids {
  value = module.vpc.private_subnets
}

output private_subnet_cidrs {
  value = module.vpc.private_subnets_cidr_blocks
}

output private_route_table_ids {
  value = module.vpc.private_route_table_ids
}

output public_subnet_ids {
  value = module.vpc.public_subnets
}

output public_subnet_cidrs {
  value = module.vpc.public_subnets_cidr_blocks
}

output public_route_table_ids {
  value = module.vpc.public_route_table_ids
}