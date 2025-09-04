#!/usr/bin/env bash
set -euo pipefail

STACK=${STACK:-crc-main}
TEMPLATE=${TEMPLATE:-cloud-resume-template.yaml}

: "${DOMAIN:?Set DOMAIN, e.g., export DOMAIN=eivistamos.co.uk}"
: "${HZID:?Set HZID (Route 53 Hosted Zone ID)}"
: "${ACM_ARN:?Set ACM_ARN (ACM cert ARN in us-east-1)}"
: "${ALERT_EMAIL:?Set ALERT_EMAIL for SNS}"
: "${CORS_ORIGIN:=https://${DOMAIN}}"
: "${STAGE:=prod}"
: "${TABLE:=crc-visitor-counter}"

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

aws cloudformation describe-stacks --stack-name "$STACK" --query 'Stacks[0].Outputs' --output table
echo "Confirm SNS email subscription to receive alerts."
