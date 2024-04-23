module "eks_core_apps" {
  source = "./module"
  # region       = "ca-central-1"
  region       = "us-east-1"
  cluster_name = "my-eks"

  # https://artifacthub.io/

  # nginx_controler
  nginx_controler_enable  = true
  certificate_arn         = "arn:aws:acm:ca-central-1:700256297630:certificate/a577763f-ccb6-4877-9bff-9547900c4029"
  nginx_controler_version = "4.10.0"

  # aws_load_balancer_controller
  alb_controller_enable  = true
  alb_controller_version = "1.7.1"

  # autoscaler
  autoscaler_enable  = true
  autoscaler_version = "9.36.0"

  # metrics_server
  metrics_server_enable  = true
  metrics_server_version = "3.12.1"

  # vpc_cni
  vpc_cni_enable      = true
  vpc_cni_version     = "1.18.0"
  subnets_filter_name = "intra"
  sg_filter_name      = "my-eks-node"
}