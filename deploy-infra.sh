#!/usr/bin/env bash
set -euo pipefail

STACK=${STACK:-resume-challenge-website}
TEMPLATE_BUCKET=${TEMPLATE_BUCKET:-resume-challenge-website-templates}
REGION=${REGION:-eu-west-2}

TEMPLATE=${TEMPLATE:-infra/main.yaml}

: "${DOMAIN:?Set DOMAIN, e.g., export DOMAIN=eivistamos.co.uk}"
: "${HZID:?Set HZID (Route 53 Hosted Zone ID)}"
: "${ACM_ARN:?Set ACM_ARN (ACM cert ARN in us-east-1)}"
: "${ALERT_EMAIL:?Set ALERT_EMAIL for SNS}"
: "${CORS_ORIGIN:=https://${DOMAIN}}"
: "${STAGE:=prod}"
: "${TABLE:=visitor-counter}"

# Check if template bucket exists

if ! aws s3api head-bucket --bucket $TEMPLATE_BUCKET 2>/dev/null; then
    echo "Bucket $TEMPLATE_BUCKET does not exist. Creating..."
    aws s3api create-bucket \
        --bucket $TEMPLATE_BUCKET \
        --region $REGION \
        --create-bucket-configuration LocationConstraint=$REGION
    echo "Bucket created."
else
    echo "Bucket $TEMPLATE_BUCKET already exists."
fi

echo "Uploading templates and lambda to S3..."
aws s3 cp infra/ s3://$TEMPLATE_BUCKET/infra/ --recursive --region $REGION
aws s3 cp lambda/lambda_function.zip s3://$TEMPLATE_BUCKET/lambda/ --region $REGION

# Deploy Main CloudFormation stack
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
    DynamoDBTableName="$TABLE" \
    TemplateBucket="$TEMPLATE_BUCKET"

# Output main stack results
aws cloudformation describe-stacks --stack-name "$STACK" --query 'Stacks[0].Outputs' --output table
echo "Confirm SNS email subscription to receive alerts."

# Get API URL from CloudFormation outputs
API_URL=$(aws cloudformation describe-stacks --stack-name "$STACK" \
          --query "Stacks[0].Outputs[?OutputKey=='ApiInvokeURL'].OutputValue" --output text)

echo "Preparing config.js..."
sed "s|PLACEHOLDER|$API_URL|g" ./site/config.js > ./site/config.deploy.js

echo "Syncing site/ folder to S3 bucket..."
aws s3 sync ./site s3://$DOMAIN --delete

echo "Overwriting config.js with API URL..."
aws s3 cp ./site/config.deploy.js s3://$DOMAIN/config.js

rm ./site/config.deploy.js

# Get CloudFront Distribution ID from CloudFormation Outputs
DIST_ID=$(aws cloudformation describe-stacks --stack-name "$STACK" \
          --query "Stacks[0].Outputs[?OutputKey=='CloudFrontDistId'].OutputValue" --output text)

echo "Invalidating CloudFront cache..."
aws cloudfront create-invalidation --distribution-id "$DIST_ID" --paths "/*"

echo "Deployment + S3 sync complete. Site live at https://$DOMAIN"
