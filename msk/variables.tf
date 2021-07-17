variable cluster_name {
  type = string
  default = "my-msk"
}

variable cluster_version {
  type = string
}

variable vpc_cidr {
  type = string
  default = "192.168.0.0/22"
}

variable subnet_cidrs {
  type = list(string)
  default = ["192.168.0.0/24", "192.168.1.0/24"]
}

variable ingress_cidrs {
  type = list(string)
}