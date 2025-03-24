echo "REPO_NAME=$1" >> $GITHUB_ENV
echo "ROLE_NAME=GitHubActionsRole" >> $GITHUB_ENV
echo "ACCOUNT_ID=$2" >> $GITHUB_ENV

ARN="arn:aws:iam::$2:role/GitHubActionsRole-${$1#*/}"
echo "TF_VAR_ROLE_ARN=$ARN" >> $GITHUB_ENV
echo "TF_VAR_ROLE_ARN=$ARN" >> env.txt