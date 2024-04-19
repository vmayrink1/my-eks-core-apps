
data "aws_caller_identity" "current" {}

data "aws_eks_clusters" "default" {}

data "aws_eks_cluster" "default" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "default" {
  name = local.cluster_name
}

data "aws_subnets" "subnets" {
  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

data "aws_subnet" "subnet_a" {
  id = element(data.aws_subnets.subnets.ids, 0)
}
data "aws_subnet" "subnet_b" {
  id = element(data.aws_subnets.subnets.ids, 1)
}
data "aws_subnet" "subnet_c" {
  id = element(data.aws_subnets.subnets.ids, 2)
}

data "aws_security_group" "sg_node" {
  filter {
    name   = "tag:Name"
    values = ["*sgdonode*"]
  }
}

locals {
  cluster_name = tolist(data.aws_eks_clusters.default.names)[0]
  oidc         = substr(data.aws_eks_cluster.default.identity[0].oidc[0].issuer, 8, length(data.aws_eks_cluster.default.identity[0].oidc[0].issuer))
  account_id   = data.aws_caller_identity.current.account_id
  vpc_id       = data.aws_eks_cluster.default.vpc_config[0].vpc_id
  subnet_a     = data.aws_subnet.subnet_a
  subnet_b     = data.aws_subnet.subnet_b
  subnet_c     = data.aws_subnet.subnet_c
  sg_node      = data.aws_security_group.sg_node
}


