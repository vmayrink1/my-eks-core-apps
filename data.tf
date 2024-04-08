
data "aws_caller_identity" "current" {}

data "aws_eks_clusters" "default" {}

data "aws_eks_cluster" "default" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "default" {
  name = local.cluster_name
}

locals {
  cluster_name = tolist(data.aws_eks_clusters.default.names)[0]
  oidc         = substr(data.aws_eks_cluster.default.identity[0].oidc[0].issuer, 8, length(data.aws_eks_cluster.default.identity[0].oidc[0].issuer))
  account_id   = data.aws_caller_identity.current.account_id
}


