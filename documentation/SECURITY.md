# Security

- **IAM Policies**: Principle of Least Privilege, Scoped to Specific Resources once deployed.
- **CloudFront OAC Lock**: S3 Bucket is Private, Specified Files only accessed via Origin Access Control.
- **API Gateway CORS**: Only the Domain of the Website is allowed.
- **IAM Roles**: Short duration credentials for GitHub only to execute the workflow for deployment.