module "msk" {
  source = "./msk"

  cluster_name    = "my-msk"
  cluster_version = "2.8.0"
  ingress_cidrs   = module.eks.private_subnet_cidrs
}

resource aws_vpc_peering_connection "eks_to_msk" {
  vpc_id      = module.eks.vpc_id
  peer_vpc_id = module.msk.vpc_id
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = {
    Name = "my-eks-to-msk"
  }
}

resource aws_route "eks_to_msk" {
  count                     = length(module.eks.private_route_table_ids)
  route_table_id            = element(module.eks.private_route_table_ids, count.index)
  destination_cidr_block    = module.msk.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.eks_to_msk.id
}

resource aws_route "mks_to_eks" {
  count                     = length(module.eks.private_route_table_ids)
  route_table_id            = element(module.msk.route_table_ids, count.index)
  destination_cidr_block    = module.eks.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.eks_to_msk.id
}

output msk_vpc_id {
  value = module.msk.vpc_id
}

output msk_bootstrap_servers {
  value = module.msk.bootstrap_servers
}
