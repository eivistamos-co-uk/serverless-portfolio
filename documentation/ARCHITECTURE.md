## Architecture Overview

This project demonstrates a full cloud-native personal portfolio website built on AWS.  
Two diagrams are provided: one for non-technical readers, and one for technical readers.

---

## Services Overview (Non-Technical Diagram)

![Overview Diagram](site/images/architecture-overview.svg)

- **S3 (Storage):** Holds website files, templates, and Lambda code  
- **CloudFront (CDN):** Delivers content quickly and securely worldwide  
- **ACM (SSL Certificates):** Provides HTTPS security  
- **Route 53 (DNS):** Routes traffic from a custom domain to the site  
- **API Gateway:** Acts as the middleman between website and backend function  
- **Lambda:** Runs the visitor counter logic  
- **DynamoDB:** Stores the visitor counter value  
- **SNS + CloudWatch:** Monitors for errors and sends email alerts  
- **GitHub Actions:** Automates updates whenever code changes are pushed

---

## Detailed Flow (Technical Diagram)

![Detailed Flow Diagram](site/images/architecture-detailed.svg)

1. **Frontend**  
   - Website assets in S3 are distributed through CloudFront  
   - Custom domain managed via Route 53 with an ACM certificate for HTTPS  

2. **Backend (Visitor Counter)**  
   - API Gateway exposes an HTTP endpoint `/count`  
   - API Gateway integrates with a Lambda function  
   - Lambda updates and retrieves count from DynamoDB  

3. **Monitoring**  
   - CloudWatch alarms monitor Lambda and API Gateway errors  
   - SNS sends alerts to a configured email  

4. **Automation (CI/CD)**  
   - GitHub Actions assumes IAM role via OIDC  
   - Runs CloudFormation templates for networking, backend, monitoring, and frontend  
   - Manages updates automatically on code push  

---

## Service Purposes

- **Amazon S3:** Website storage + Lambda deployment package  
- **Amazon CloudFront:** Global content delivery + HTTPS  
- **AWS Certificate Manager (ACM):** SSL/TLS certificates  
- **Amazon Route 53:** Domain routing + DNS records  
- **Amazon API Gateway:** Public API endpoint for counter  
- **AWS Lambda:** Serverless compute for visitor counter  
- **Amazon DynamoDB:** NoSQL database for counter state  
- **Amazon CloudWatch:** Alarms + monitoring  
- **Amazon SNS:** Email notifications for errors  
- **GitHub Actions:** CI/CD automation  