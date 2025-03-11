aws eks update-kubeconfig --name show-room-eks-eks-cluster --region us-east-1 --role-arn arn:aws:iam::ACCOUNT_ID:role/EKS-Admin-Role
kubectl get pods --token $(aws eks get-token --cluster-name show-room-eks-eks-cluster --output json | jq -r '.status.token')
