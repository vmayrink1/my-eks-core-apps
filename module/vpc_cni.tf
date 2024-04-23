resource "helm_release" "cni_config" {
  count      = var.vpc_cni_enable ? 1 : 0
  name       = "aws-vpc-cni"
  chart      = "aws-vpc-cni"
  repository = "https://aws.github.io/eks-charts"
  version    = var.vpc_cni_version
  namespace  = "kube-system"
  # values = [
  #   templatefile("./module/helm-values/values-cni.yaml", {
  #     region   = "${local.region}"
  #     subnet_1 = "${local.subnet_1}"
  #     subnet_2 = "${local.subnet_2}"
  #     subnet_3 = "${local.subnet_3}"
  #     sg_node  = "${local.sg_node}"
  #     az_1
  #   })
  # ]
}