module "eks_core_apps" {
  source       = "./module"
  region       = "us-east-1"
  cluster_name = "my-eks"

  # https://artifacthub.io/

  # nginx_controler
  nginx_controler_enable  = true
  certificate_arn         = ""
  nginx_controler_version = "4.10.0"

  # kube_proxy
  kube_proxy_enable  = true
  kube_proxy_version = "v1.29.1-minimal-eksbuild.2"

  # coredns
  coredns_enable  = true
  coredns_version = "v1.11.1-eksbuild.6"

  # vpc_cni
  vpc_cni_enable      = true
  vpc_cni_version     = "1.18.0"
  subnets_filter_name = "intra"      # subnets da rede CNI
  sg_filter_name      = "node" # sg do node

  # aws_load_balancer_controller
  alb_controller_enable  = true
  alb_controller_version = "1.7.1"

  # autoscaler
  autoscaler_enable  = true
  autoscaler_version = "9.36.0"

  # metrics_server
  metrics_server_enable  = true
  metrics_server_version = "3.12.1"

  # kube_dashboard
  kube_dashboard_enable        = true
  kube_dashboard_version       = "7.2.3"
  kube_dashboard_ingress_class = "nginx"
  kube_dashboard_url           = null

  # kubecost
  kubecost_enable        = false
  kubecost_version       = "2.2.2"
  kubecost_ingress_class = "nginx"
  kubecost_url           = null
}