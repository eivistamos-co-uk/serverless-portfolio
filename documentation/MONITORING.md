# Monitoring & Logging

- **Lambda logs**: CloudWatch log group /aws/lambda/<function>
- **API Gateway logs**: JSON logs in CloudWatch
- **DynamoDB metrics**: read/write capacity, latency
- **Alarms**:
  - Lambda-Errors → SNS to the Email for Alerts
  - API Gateway Errors -> SNS to the Email for Alerts