export AWS_PROFILE=anderson
aws eks --region us-east-1 update-kubeconfig --name my-eks

kubectl get pods -A | grep autoscaler
kubectl rollout restart deploy -n kube-system autoscaler-aws-cluster-autoscaler
kubectl -n kube-system logs -f deployment.apps/autoscaler-aws-cluster-autoscaler

kubectl get pods -A | grep aws-load-balancer-controller
kubectl rollout restart deploy -n kube-system aws-load-balancer-controller
kubectl -n kube-system logs -f deployment.apps/aws-load-balancer-controller

kubectl get pods -A | grep ingress-ingress-nginx-controller
kubectl rollout restart deploy -n kube-system ingress-ingress-nginx-controller
kubectl -n ingress-nginx logs -f deployment.apps/ingress-ingress-nginx-controller
helm uninstall -n ingress-nginx ingress

kubectl delete -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/v1.17.1/config/master/aws-k8s-cni.yaml

kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')