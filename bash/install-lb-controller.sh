LB_CRTLR_IS_INSTALLED=$(kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller \
                        --no-headers | wc -l)

if [ "$LB_CRTLR_IS_INSTALLED" -eq 0 ]; then
    helm repo add eks https://aws.github.io/eks-charts
    
    helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
               --set clusterName=$1 \
               --set serviceAccount.create=false \
               --set serviceAccount.name=aws-load-balancer-controller \
               --namespace kube-system
else
        echo "AWS Load Balancer Controller is already installed."
fi