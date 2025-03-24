VALUE=$(terraform output -raw $2)
echo "$1=$VALUE" >> $GITHUB_ENV