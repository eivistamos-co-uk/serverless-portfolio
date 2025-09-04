# Cloud Resume Challenge — Baseline IaC

## Files
- `cloud-resume-template.yaml` — CloudFormation stack S3 private + CloudFront OAC + Route 53 A-record + DynamoDB + Lambda + HTTP API + CloudWatch Alarms + SNS.
- `deploy.sh` — deploy stack via AWS CLI.

## Deploy Steps
1. Prerequisites
   - ACM certificate for your apex domain in us-east-1.  
   - Route 53 hosted zone ID.  
   - AWS CLI configured with access keys.

2. Set environment variables
```cmd
set DOMAIN=eivistamos.co.uk
set HZID=your_hosted_zone_id
set ACM_ARN=ACM cert ARN in us-east-1
set ALERT_EMAIL=eivistamos@gmail.com
set CORS_ORIGIN=https%DOMAIN%
set STAGE=prod
set TABLE=crc-visitor-counter
