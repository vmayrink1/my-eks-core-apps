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

CNI
kubectl describe daemonset aws-node -n kube-system | grep Image
kubectl delete -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/v1.17.1/config/master/aws-k8s-cni.yaml
kubectl describe daemonset aws-node -n kube-system | grep AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG
kubectl describe daemonset aws-node -n kube-system | grep ENI_CONFIG_LABEL_DEF
kubectl describe daemonset aws-node -n kube-system | grep ENABLE_PREFIX_DELEGATION
kubectl get ENIConfigs
kubectl -n kube-system logs -f daemonset.apps/aws-node
kubectl get pods -A | grep aws-node
kubectl get pods -A -o wide

kube-proxy
kubectl describe daemonset kube-proxy -n kube-system | grep Image
kubectl get pods -A | grep kube-proxy

coredns
kubectl describe deployment coredns --namespace kube-system | grep coredns: | cut -d : -f 3
kubectl get pods -A | grep coredns

kubectl get deploy -A | grep kubernetes-dashboard
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')

helm uninstall -n kubecost kubecost
helm uninstall -n kubernetes-dashboard kubernetes-dashboard
helm uninstall -n kube-system metrics-server

kubectl get pods -A | grep -v Running | awk '{print $2, "-n", $1}' | xargs -n3 kubectl delete pod