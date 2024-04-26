resource "helm_release" "kube_dashboard" {
  count            = var.kube_dashboard_enable ? 1 : 0
  name             = "kubernetes-dashboard"
  repository       = "https://kubernetes.github.io/dashboard"
  version          = var.kube_dashboard_version
  chart            = "kubernetes-dashboard"
  namespace        = "kubernetes-dashboard"
  create_namespace = true
  values = [
    templatefile("./module/helm-values/values-kube-dashboard.yaml", {
      kube_dashboard_url = "${var.kube_dashboard_url}"
      kube_dashboard_ingress_class = "${var.kube_dashboard_ingress_class}"
    })
  ]
}

