# Serverless Website with CI/CD + IaC on AWS  

A cloud-hosted portfolio website demonstrating **practical AWS engineering skills**.  
This project implements a static website with a visitor counter, full CI/CD automation, and infrastructure as code, covering the **core capabilities of a cloud engineer**.  

Built as part of the [Cloud Resume Challenge](https://cloudresumechallenge.dev/docs/the-challenge/aws), the repository highlights:  
- **Cloud Infrastructure**: S3, CloudFront, Route 53, API Gateway, Lambda, DynamoDB, CloudWatch, IAM, ACM  
- **Automation**: GitHub Actions CI/CD pipelines, CloudFormation templates  
- **Best Practices**: Monitoring, least-privilege IAM, cleanup instructions  

---

## Project Overview  

- **Non-Technical Summary**: A personal portfolio website, served securely and globally through AWS. Visitors can view my portfolio and see a live counter that tracks how many people have accessed the site.  
- **Technical Summary**: A static front end on S3 + CloudFront, secured with TLS (ACM), custom domain via Route 53, dynamic visitor counter via API Gateway → Lambda → DynamoDB, all monitored by CloudWatch, and deployed automatically with GitHub Actions and CloudFormation stacks.  

---

## Architecture  

### High-Level Diagram (non-technical)  
![Overview Diagram](site/images/architecture-overview.svg)

This overview shows the core AWS services used, grouped by their role in the solution.

### Detailed Flow (technical)  
![Detailed Flow Diagram](site/images/architecture-detailed.svg)

Covers CI/CD pipeline, request/response path, logging, and permissions.

---

## Deployment Instructions  

### Prerequisites  
- AWS account with admin access  
- Registered domain and hosted zone in Route 53 
- ACM Certificate in us-east-1 region 
- GitHub Set Up as Identity Provider in AWS

### Steps  
1. In IAM, either create a single policy or separate policies for each service(recommended) to be used in the GitHub Role in the next step:
   - See [POLICY.md](documentation/POLICY.md) for the policy JSON code to be referenced.
2. In IAM, Create a Role for GitHub:
   - Select entity type as: Web Identity
   - Select Web Identity as: GitHub or githubusercontent.com
   - Select Audience
   - Specify Organisation as your GitHub Account Username e.g. 'eivistamos-co-uk'
   - Add Permission(s) policies created earlier
   - Create Role
3. Clone the Repository and configure the following GitHub Actions Secrets:
   - AWS_ACCOUNT_ID
   - HOSTED_ZONE_ID
   - ACM_CERTIFICATE_ARN
   - EMAIL_FOR_ALERTS
4. Review the github\workflows\deploy.yml file and update the ENV variables for your requirements:
   - AWS_REGION
   - TEMPLATE_BUCKET_NAME
   - STACK_NAME
   - DOMAIN_NAME
   - STAGE_NAME
   - DYNAMO_DB_TABLE_NAME
   - IAM_GITHUB_ROLE_NAME
5. Update the HTML and CSS files within the site folder to your liking.
6. Add, Commit, and Push code.
7. GitHub Actions will build & deploy the website.  

---

## IAM Policies  

- Policies are written with **wildcards** in the resource section to ease initial deployment.  
- For production use, replace wildcards with **specific ARNs** once resources are created.  
- See [POLICY.md](documentation/POLICY.md) for full explanation.  

---

## Testing the Site  

1. Visit your domain (e.g. `https://yourdomain.com`).  
2. Confirm the page loads.  
3. Refresh to check visitor counter increments.  
4. Review CloudWatch logs for Lambda/API Gateway.  

---

## Cleanup  

To avoid costs: 
- Empty and Delete S3 Buckets.
- Delete the main CloudFormation stack. This should result in the sub-stacks being deleted too. 
- Disable or delete CI/CD GitHub Actions.  
