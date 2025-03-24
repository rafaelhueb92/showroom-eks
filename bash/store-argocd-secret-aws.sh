#!/bin/bash

SECRET_NAME=$ARGOCD_SECRET
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 --decode)

if [ -z "$ARGOCD_PASSWORD" ]; then
  echo "Failed to retrieve ArgoCD password"
  exit 1
fi

SECRET_JSON=$(jq -n \
                  --arg argocd_user "admin" \
                  --arg argocd_password "$ARGOCD_PASSWORD" \
                  '{
                    argocd_user: $argocd_user,
                    argocd_password: $argocd_password
                  }')

# Store the secret in AWS Secrets Manager
aws secretsmanager update-secret \
  --secret-id "$SECRET_NAME" \
  --secret-string "$SECRET_JSON"

# Check if the secret update was successful
if [ $? -eq 0 ]; then
  echo "Successfully updated the ArgoCD password in Secrets Manager."
else
  echo "Failed to update the ArgoCD password in Secrets Manager."
  exit 1
fi
