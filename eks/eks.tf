provider "kubernetes" {
  host        = data.aws_eks_cluster.cluster.endpoint
  token       = data.aws_eks_cluster_auth.cluster.token
  config_path = var.kubeconfig_path
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.1.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets

  node_groups = {
    main = {
      desired_capacity = 1
      max_capacity     = 3
      min_capacity     = 0

      instance_type = "m5.large"
    }
  }

  write_kubeconfig = true
  kubeconfig_output_path = var.kubeconfig_path
}

output cluster_id {
  value = module.eks.cluster_id
}

output node_group_arn {
  value = module.eks.node_groups["main"].arn
}

output node_group_name {
  value = module.eks.node_groups["main"].node_group_name
}

output node_group_asg_name {
  value = module.eks.node_groups["main"]["resources"][0].autoscaling_groups[0].name
}