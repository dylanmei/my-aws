variable cluster_name {
  type = string
  default = "my-eks"
}

variable cluster_version {
  type = string
}

variable vpc_cidr {
  type = string
  default = "172.16.0.0/16"
}

variable private_subnet_cidrs {
  type = list(string)
  default = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
}

variable public_subnet_cidrs {
  type = list(string)
  default = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
}

variable kubeconfig_path {
  type = string
  default = "./kubeconfig"
}