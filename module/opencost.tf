## Instalar pelas instrucoes em: https://docs.aws.amazon.com/eks/latest/userguide/cost-monitoring.html
resource "helm_release" "opencost" {
  count            = var.opencost_enable ? 1 : 0
  name             = "opencost"
  repository       = "https://opencost.github.io/opencost-helm-chart"
  version          = var.opencost_version
  chart            = "opencost-helm-chart"
  namespace        = "opencost"
  create_namespace = true
  values = [
    templatefile("./module/helm-values/values-opencost.yaml", {
      opencost_url           = "${var.opencost_url}"
      opencost_ingress_class = "${var.opencost_ingress_class}"
    })
  ]
}