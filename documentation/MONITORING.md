# Monitoring & Logging

- **Lambda logs**: CloudWatch log group /aws/lambda/<function>
- **API Gateway logs**: JSON logs in CloudWatch
- **DynamoDB metrics**: read/write capacity, latency
- **Alarms**:
  - CRC-Lambda-Errors → SNS ($ALERT_EMAIL)
  - API Gateway Errors -> SNS ($ALERT_EMAIL)