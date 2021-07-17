module "eks" {
  source = "./eks"

  cluster_name    = "my-eks"
  cluster_version = "1.20"
}

output eks_vpc_id {
  value = module.eks.vpc_id
}

output eks_cluster_id {
  value = module.eks.cluster_id
}

output eks_node_group_arn {
  value = module.eks.node_group_arn
}

output eks_node_group_name {
  value = module.eks.node_group_name
}

output eks_node_group_asg_name {
  value = module.eks.node_group_asg_name
}
