resource "helm_release" "cni_config" {
  name       = "aws-vpc-cni"
  chart      = "aws-vpc-cni"
  repository = "https://aws.github.io/eks-charts"
  version    = "1.18.0"
  namespace  = "kube-system"
  values = [
    templatefile("helm-values/values-cni.yaml", {
      region = "${local.region}"
      subnet_a = "${local.subnet_a}"
      subnet_b = "${local.subnet_b}"
      subnet_c = "${local.subnet_c}"
      sg_node  = "${local.sg_node}"
    })
  ]
}