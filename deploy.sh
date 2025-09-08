#!/usr/bin/env bash
set -euo pipefail

STACK=${STACK:-resume-challenge-website}
TEMPLATE=${TEMPLATE:-cloud-resume-template.yaml}

: "${DOMAIN:?Set DOMAIN, e.g., export DOMAIN=eivistamos.co.uk}"
: "${HZID:?Set HZID (Route 53 Hosted Zone ID)}"
: "${ACM_ARN:?Set ACM_ARN (ACM cert ARN in us-east-1)}"
: "${ALERT_EMAIL:?Set ALERT_EMAIL for SNS}"
: "${CORS_ORIGIN:=https://${DOMAIN}}"
: "${STAGE:=prod}"
: "${TABLE:=visitor-counter}"

# Deploy CloudFormation stack
aws cloudformation deploy \
  --stack-name "$STACK" \
  --template-file "$TEMPLATE" \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    DomainName="$DOMAIN" \
    HostedZoneId="$HZID" \
    ACMCertificateArn="$ACM_ARN" \
    AllowedCorsOrigin="$CORS_ORIGIN" \
    EmailForAlerts="$ALERT_EMAIL" \
    StageName="$STAGE" \
    DynamoDBTableName="$TABLE"

# Output stack results
aws cloudformation describe-stacks --stack-name "$STACK" --query 'Stacks[0].Outputs' --output table
echo "Confirm SNS email subscription to receive alerts."

# Get API URL from CloudFormation outputs
API_URL=$(aws cloudformation describe-stacks --stack-name "$STACK" \
          --query "Stacks[0].Outputs[?OutputKey=='ApiInvokeURL'].OutputValue" --output text)

# Replace placeholder in script.js
sed -i "s|{{API_URL}}|$API_URL|g" ./site/script.js

# Sync site folder to S3 and invalidate CloudFront
echo "Syncing site/ folder to S3 bucket..."
aws s3 sync ./site s3://$DOMAIN --delete

# Get CloudFront Distribution ID from CloudFormation Outputs
DIST_ID=$(aws cloudformation describe-stacks --stack-name "$STACK" \
          --query "Stacks[0].Outputs[?OutputKey=='CloudFrontDistId'].OutputValue" --output text)

echo "Invalidating CloudFront cache..."
aws cloudfront create-invalidation --distribution-id "$DIST_ID" --paths "/*"

echo "Deployment + S3 sync complete. Site live at https://$DOMAIN"
