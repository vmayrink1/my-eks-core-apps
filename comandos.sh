export AWS_PROFILE=anderson
aws eks --region us-east-1 update-kubeconfig --name my-eks

kubectl get pods -A | grep autoscaler
kubectl rollout restart deploy -n kube-system cluster-autoscaler
helm show values autoscaler/cluster-autoscaler
kubectl -n kube-system logs -f deployment.apps/autoscaler-aws-cluster-autoscaler

kubectl get pods -A | grep aws-load-balancer-controller
kubectl rollout restart deploy -n kube-system aws-load-balancer-controller
helm show values eks/aws-load-balancer-controller
kubectl -n kube-system logs -f deployment.apps/aws-load-balancer-controller

kubectl get pods -A | grep ingress-ingress-nginx-controller
kubectl rollout restart deploy -n kube-system ingress-ingress-nginx-controller
kubectl -n ingress-nginx logs -f deployment.apps/ingress-ingress-nginx-controller
helm show values ingress-nginx/ingress-nginx
helm get values -n ingress ingress-nginx
helm uninstall -n ingress-nginx ingress