echo "REPO_NAME=${{ github.repository }}" >> $GITHUB_ENV
echo "ROLE_NAME=GitHubActionsRole" >> $GITHUB_ENV
echo "ACCOUNT_ID=${{ secrets.AWS_ACCOUNT_ID }}" >> $GITHUB_ENV

ARN="arn:aws:iam::$ACCOUNT_ID:role/$ROLE_NAME-${REPO_NAME#*/}"
echo "TF_VAR_ROLE_ARN=$ARN" >> $GITHUB_ENV