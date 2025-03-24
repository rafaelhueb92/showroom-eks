ARGO_IS_INSTALLED=$(kubectl get ns argocd --no-headers | wc -l)
if [ $ARGO_IS_INSTALLED -gt 0 ]; then
    echo "ARGO IS ALREADY INSTALLED!"
else
    helm upgrade --install argocd bitnami/argo-cd --namespace argocd --create-namespace
    helm test argocd --namespace argocd
    bash store-argocd-secret-aws.sh
fi

