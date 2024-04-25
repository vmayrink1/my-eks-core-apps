## Instalar pelas instrucoes em: https://docs.aws.amazon.com/eks/latest/userguide/cost-monitoring.html
resource "helm_release" "kubecost" {
  name             = "kubecost"
  repository       = "https://kubecost.github.io/cost-analyzer"
  version          = "1.108.0"
  chart            = "cost-analyzer"
  namespace        = "kubecost"
  timeout          = 600
  create_namespace = true
  values = [
    file("./module/helm-values/values-kubecost.yaml")
  ]
  set {
    name  = "imagePullSecrets[0].name"
    value = kubernetes_secret_v1.dockerconfig["kube-system"].metadata.0.name
  }

  depends_on = [
    helm_release.ebs_csi_driver
  ]
}