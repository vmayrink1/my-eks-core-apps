
resource "helm_release" "ingress_gateway" {
  name             = "ingress"
  chart            = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  version          = "4.10.0"
  namespace        = "ingress-nginx"
  create_namespace = true

  # Problema com o SSL no nginx. https://medium.com/faun/nginx-ingress-controller-for-cross-namespace-support-and-fix-308-redirect-loops-with-aws-nlb-9c9ca58deeaa
  # Para configurar direto pelo YAML existe um GIT em progresso: https://github.com/kubernetes/ingress-nginx/issues/6868
  values = [
    file("helm-values/values-nginx.yaml")
    # templatefile("values.yaml", {
    #    SSL_CERT = "${aws_acm_certificate.porto_cert.arn}"
    # })
  ]
  depends_on = [
    helm_release.aws_load_balancer_controller
  ]
}

# # Os certificados são fornecidos pelo time da porto
# resource "aws_acm_certificate" "porto_cert" {
#   private_key       = file("${path.module}/certificate-novo-ambiente/${lower(var.environment)}/novo-ambiente.${lower(var.environment)}.sinapse.porto.key")
#   certificate_body  = file("${path.module}/certificate-novo-ambiente/${lower(var.environment)}/novo-ambiente.${lower(var.environment)}.sinapse.porto.crt")
#   certificate_chain = file("${path.module}/certificate-novo-ambiente/${lower(var.environment)}/cacert.txt")
#   tags = {
#     environment  = var.environment
#     cluster_name = var.cluster_name
#   }
# }



