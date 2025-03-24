helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
           --set clusterName=${{ env.EKS_CLUSTER_NAME }} \
           --set serviceAccount.create=false \
           --set serviceAccount.name=aws-load-balancer-controller \
           --namespace kube-system