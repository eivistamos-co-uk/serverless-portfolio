# Cloud Resume Challenge – Architecture

## Components
- **S3**: static frontend hosting (private, OAC)
- **CloudFront**: CDN + HTTPS + OAC → S3
- **Route 53**: DNS for $DOMAIN
- **ACM**: TLS certificate in us-east-1
- **DynamoDB**: visitor counter table ($TABLE)
- **Lambda**: CRUD counter logic
- **API Gateway v2**: HTTP API → Lambda, CORS enabled for $CORS_ORIGIN
- **CloudWatch**: logs + alarms
- **SNS**: email alerts to $ALERT_EMAIL

## Flow
User → CloudFront (HTTPS) → S3 (static files)  
User → CloudFront → API Gateway → Lambda → DynamoDB → return visitor count