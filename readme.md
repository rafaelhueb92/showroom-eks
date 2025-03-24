# Showroom EKS Application

# ArgoCD Configuration for EKS Cluster

This guide provides step-by-step instructions on how to configure ArgoCD to deploy applications to an **Amazon EKS cluster**.

## Prerequisites

- An **Amazon EKS cluster** set up and running
- **kubectl** configured with access to the EKS cluster
- **ArgoCD installed** in the cluster
- AWS CLI installed and configured

## 1. Configure Destination Server in ArgoCD Application Manifest

### **A. If ArgoCD is Running Inside the Same EKS Cluster**

If ArgoCD is installed **inside the same EKS cluster**, use the **internal Kubernetes API server**:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-app
  namespace: argocd
spec:
  project: my-project
  source:
    repoURL: "https://github.com/my-org/my-repo.git"
    targetRevision: main
    path: manifests
  destination:
    server: https://kubernetes.default.svc
    namespace: dev
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

This ensures ArgoCD deploys the application **inside the same EKS cluster**.

---

### **B. If ArgoCD is Managing a Different EKS Cluster**

If ArgoCD is managing a cluster **different from where it is installed**, you need the **external API URL of the target EKS cluster**.

Get the **EKS API server URL**:

```sh
aws eks describe-cluster --name my-cluster --query "cluster.endpoint" --output text
```

Use the returned URL in the application manifest:

```yaml
destination:
  server: "https://XXXXXXXX.gr7.us-east-1.eks.amazonaws.com"
  namespace: dev
```

⚠️ **Ensure that ArgoCD has IAM permissions (IRSA) to authenticate with the EKS API.**

---

## 2. Update kubeconfig for EKS Cluster Access

To access your EKS cluster, update your kubeconfig file using:

```sh
aws eks update-kubeconfig --region your-region --name your-cluster-name
```

This command configures `kubectl` to communicate with your EKS cluster.

Verify connection:

```sh
kubectl get nodes
```

---

## 3. Assume IAM Role for AWS Authentication

If you need to assume an IAM role to interact with AWS resources, configure your AWS profile with:

```sh
aws configure set role_arn arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME --profile my-profile
aws configure set source_profile default --profile my-profile
```

To assume the role and verify credentials:

```sh
aws sts get-caller-identity --profile my-profile
```

For more details, see the AWS documentation: [AWS CLI Assume Role](https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-role.html)

---

## 4. Add the EKS Cluster to ArgoCD

If ArgoCD does not detect your EKS cluster automatically, add it manually:

```sh
argocd cluster list
```

If your cluster is missing, add it using:

```sh
argocd cluster add CONTEXT_NAME
```

Get the cluster context with:

```sh
kubectl config get-contexts
```

---

## 5. Verify ArgoCD Connection to EKS

Check if ArgoCD can see the cluster and applications:

```sh
argocd app list
```

To manually sync an application:

```sh
argocd app sync my-app
```

---

## 6. Exposing ArgoCD via AWS Load Balancer Controller

If you want to access the ArgoCD UI via an **AWS ALB with ACM**, configure an Ingress:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-ingress
  namespace: argocd
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/group.name: argocd-ingress-group
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}]'
    alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:region:account-id:certificate/cert-id
    alb.ingress.kubernetes.io/ssl-redirect: "443"
spec:
  ingressClassName: alb
  rules:
    - host: argocd.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: argocd-server
                port:
                  number: 80
```

Apply the manifest:

```sh
kubectl apply -f argocd-ingress.yaml
```

Check the ALB URL:

```sh
kubectl get ingress -n argocd
```

Now, ArgoCD should be accessible at **https://argocd.example.com**.

---

## Summary

| Scenario                                       | Correct `destination.server`                       |
| ---------------------------------------------- | -------------------------------------------------- |
| ArgoCD running **inside the same EKS cluster** | `https://kubernetes.default.svc`                   |
| ArgoCD managing **an external EKS cluster**    | EKS API URL (`https://XXXXXXXX.eks.amazonaws.com`) |
