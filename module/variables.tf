# cluster_eks
variable "region" {
  type = string
}
variable "cluster_name" {
  type = string
}

# nginx_controler
variable "nginx_controler_enable" {
  type = bool
  default = false
}
variable "certificate_arn" {
  type = string
  default = null
}
variable "nginx_controler_version" {
  type = string
  default = null
}

# aws_load_balancer_controller
variable "alb_controller_enable" {
  type = bool
  default = false
}
variable "alb_controller_version" {
  type = string
  default = null
}

# autoscaler
variable "autoscaler_enable" {
  type = bool
  default = false
}
variable "autoscaler_version" {
  type = string
  default = null
}

# metrics_server
variable "metrics_server_enable" {
  type = bool
  default = false
}
variable "metrics_server_version" {
  type = string
  default = null
}

# vpc_cni
variable "vpc_cni_enable" {
  type = bool
  default = false
}
variable "vpc_cni_version" {
  type = string
  default = null
}