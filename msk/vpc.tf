
data aws_availability_zones "available" {
  state = "available"
}

resource aws_vpc "msk" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    "Name" = var.cluster_name
  }
}

resource aws_subnet "msk" {
  count             = min(3, length(var.subnet_cidrs))
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  cidr_block        = element(var.subnet_cidrs, count.index)
  vpc_id            = aws_vpc.msk.id
  tags = {
    "Name" = "${var.cluster_name}-${element(data.aws_availability_zones.available.names, count.index)}"
  }
}

resource aws_security_group "msk" {
  vpc_id = aws_vpc.msk.id

  ingress {
    from_port   = 9092
    to_port     = 9094
    protocol    = "TCP"
    cidr_blocks = var.ingress_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = var.cluster_name
  }
}

data aws_route_tables "msk" {
  vpc_id = aws_vpc.msk.id
}


output vpc_id {
  value = aws_vpc.msk.id
}

output vpc_cidr {
  value = aws_vpc.msk.cidr_block
}

output subnet_ids {
  value = aws_subnet.msk.*.id
}

output subnet_cidrs {
  value = aws_subnet.msk.*.cidr_block
}

output route_table_ids {
  value = flatten([data.aws_route_tables.msk.ids])
}