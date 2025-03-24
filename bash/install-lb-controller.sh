helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
           --set clusterName=$1 \
           --set serviceAccount.create=false \
           --set serviceAccount.name=aws-load-balancer-controller \
           --namespace kube-system