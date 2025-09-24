# POLICY.md

## IAM Policy for Cloud Resume Challenge

This project uses a GitHub Actions workflow to deploy AWS resources through CloudFormation.  
For this to work, you must first create an IAM role and attach a policy that grants the workflow enough permissions to manage the required resources.

---

## Policy Structure

The policy in this repo is structured by **service**, with separate statements for CloudFormation, S3, DynamoDB, CloudFront, IAM, API Gateway, Lambda, SNS, CloudWatch, Route 53, and ACM.

Each block enables the GitHub Actions runner to:
- Create, update, and delete resources
- Read resource configuration
- Apply tags when needed

---

## Wildcards vs Least Privilege

To simplify deployment, the included policy uses **wildcards** (`"Resource": "*"`) or generic service ARNs in some places.  
This is necessary because many ARNs are only created at deployment time (for example, new Lambda functions or CloudFront distributions).  

**Drawback:** Wildcards are overly permissive and grant access beyond the intended scope.

**Recommendation for least privilege:**
1. Deploy the stack once with wildcards.  
2. Collect the actual ARNs of created resources (via CloudFormation outputs or AWS CLI).  
3. Update the policy to replace `"*"` with specific ARNs.  
4. Keep IAM permissions scoped only to what the workflow truly needs.

---

## PassRole Note

The workflow needs `iam:PassRole` so that CloudFormation can attach IAM roles (for example, Lambda execution roles).  
Restrict this to only the specific roles created for this project:
```json
"Resource": "arn:aws:iam::<account-id>:role/resume-challenge-*"
