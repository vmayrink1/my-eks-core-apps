terraform {
  backend "s3" {
    bucket = "portofaz-dev-terraform-states-bucket"
    key    = "infraestrutura/eks-core-apps/state-dev.tfstate"
    region = "ca-central-1"
  }
}
