https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-role.html
aws eks update-kubeconfig --name <cluster-name> --profile <profile-name>
I could use an external redis for argo:

helm upgrade --install argocd bitnami/argo-cd \
 --namespace argocd --create-namespace \
 --set redis.enabled=false \
 --set configs.credentialTemplates.externalRedis="redis://10.100.200.10:6379"
