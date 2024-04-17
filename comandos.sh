export AWS_PROFILE=anderson
aws eks --region us-east-1 update-kubeconfig --name my-eks

kubectl get pods -A | grep autoscaler
kubectl rollout restart deploy -n kube-system autoscaler-aws-cluster-autoscaler
kubectl -n kube-system logs -f deployment.apps/autoscaler-aws-cluster-autoscaler
helm get values -n kube-system autoscaler

kubectl get pods -A | grep aws-load-balancer-controller
kubectl rollout restart deploy -n kube-system aws-load-balancer-controller
kubectl -n kube-system logs -f deployment.apps/aws-load-balancer-controller
helm get values -n kube-system aws-load-balancer-controller

kubectl get pods -A | grep ingress-ingress-nginx-controller
kubectl rollout restart deploy -n kube-system ingress-ingress-nginx-controller
kubectl -n ingress-nginx logs -f deployment.apps/ingress-ingress-nginx-controller

helm get values -n ingress ingress-nginx
helm uninstall -n ingress-nginx ingress