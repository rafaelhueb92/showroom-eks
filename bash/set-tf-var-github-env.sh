VALUE=$(terraform output -raw "$2" 2>/dev/null || echo "")
SANITIZED_VALUE=$(echo "$VALUE" | sed 's/::debug::Terraform//g')
echo $SANITIZED_VALUE $1

if [ -n "$SANITIZED_VALUE" ]; then
  echo "$1=$SANITIZED_VALUE" >> "$GITHUB_ENV"
  echo "$1=$SANITIZED_VALUE" >> env.txt
else
  echo "Warning: Terraform output '$2' not found or empty"
fi
