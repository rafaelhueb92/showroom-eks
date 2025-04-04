VALUE=$(terraform output -raw "$2" 2>/dev/null || echo "")
SANITIZED_VALUE=$(echo "$VALUE" | sed 's/::debug::Terraform//g')

if [ -n "$SANITIZED_VALUE" ]; then
  echo "$1=$SANITIZED_VALUE" >> $GITHUB_ENV
else
  echo "Warning: Terraform output '$2' not found or empty"
fi

echo "***************************************************************"