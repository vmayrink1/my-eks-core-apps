resource "helm_release" "kube-dashboard" {
  name             = "kubernetes-dashboard"
  repository       = "https://kubernetes.github.io/dashboard"
  version          = "7.1.3"
  chart            = "kubernetes-dashboard"
  namespace        = "kubernetes-dashboard"
  create_namespace = true
  values = [
    file("./module/helm-values/values-kube-dashboard.yaml")
  ]
}

