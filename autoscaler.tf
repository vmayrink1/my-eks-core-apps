
# // Para o auto-scaler funcionar
# # worker_iam_role_arn
# data "aws_iam_role" "worker_iam_role_arn" {
#   name = var.eks_worker_iam_role_name
# }
# Autoscaler tem diversas configurações. Movido de lugar para organizar melhor
# helm template autoscaler --namespace kube-system --set autoDiscovery.clusterName=eks-cluster --set rbac.serviceAccount.annotations.eks\.amazonaws\.com/role-arn=arn:aws:iam::123456789012:role/eksctl-eks-cluster-nodegroup-ng-1-NodeInstanceRole-1VZJ3GZGZJW3 --set rbac.serviceAccount.create=true --set rbac.serviceAccount.name=cluster-autoscaler --set rbac.psp.create=true --set rbac.psp.name=cluster-autoscaler --set rbac.psp.useAppArmor=false --set rbac.psp.usePodSecurityPolicy=false --set rbac.rbac.create=true --set rbac.rbac.serviceAccountName=cluster-autoscaler --set rbac.rbac.serviceAccountNameOverride=cluster-autoscaler --set rbac.rbac.serviceAccountNameOverride=cluster-autoscaler --set rbac.rbac.useAppArmor=false --set rbac.rbac.usePodSecurityPolicy=false
resource "helm_release" "autoscaler" {
  name       = "autoscaler"
  chart      = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  version    = "9.36.0"
  namespace  = "kube-system"

  set {
    name  = "awsRegion"
    value = local.region
  }
  set {
    name  = "autoDiscovery.clusterName"
    value = data.aws_eks_cluster.default.name
  }
  set {
    name  = "replicaCount"
    value = 1
  }
  set {
    name  = "resources.requests.cpu"
    value = "100m"
  }
  set {
    name  = "resources.requests.memory"
    value = "300Mi"
  }
  set {
    name  = "rbac.serviceAccount.create"
    value = "false"
  }
  set {
    name  = "rbac.serviceAccount.name"
    value = "cluster-autoscaler"
  }
  depends_on = [
    kubernetes_service_account_v1.aws_cluster_autoscaler_sa
  ]
}

resource "kubernetes_service_account_v1" "aws_cluster_autoscaler_sa" {
  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/name"      = "cluster-autoscaler"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${local.account_id}:role/${aws_iam_role.eks_cluster_autoscaler_role.name}"
    }
  }
}

# ROLES e POLICY
resource "aws_iam_role" "eks_cluster_autoscaler_role" {
  name = "AmazonEKSClusterAutoscalerRole"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Federated" : "arn:aws:iam::${local.account_id}:oidc-provider/${local.oidc}"
          },
          "Action" : "sts:AssumeRoleWithWebIdentity",
          "Condition" : {
            "StringEquals" : {
              "${local.oidc}:aud" : "sts.amazonaws.com",
              "${local.oidc}:sub" : "system:serviceaccount:kube-system:cluster-autoscaler"
            }
          }
        }
      ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_cluster_autoscaler_role_policy" {
  role       = aws_iam_role.eks_cluster_autoscaler_role.name
  policy_arn = aws_iam_policy.eks_cluster_autoscaler_policy.arn
}


resource "aws_iam_policy" "eks_cluster_autoscaler_policy" {
  name        = "AmazonEKSClusterAutoscalerPolicy"
  description = "Policy to work with autoscale"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeScalingActivities",
        "autoscaling:DescribeTags",
        "ec2:DescribeInstanceTypes",
        "ec2:DescribeLaunchTemplateVersions"
      ],
      "Resource": ["*"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeImages",
        "ec2:GetInstanceTypesFromInstanceRequirements",
        "eks:DescribeNodegroup"
      ],
      "Resource": ["*"]
    }
  ]
}
EOF
}