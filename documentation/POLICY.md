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
```

---

## The Policy
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CloudFormationDeploy",
            "Effect": "Allow",
            "Action": [
                "cloudformation:ValidateTemplate",
                "cloudformation:DescribeStacks",
                "cloudformation:CreateChangeSet",
                "cloudformation:DescribeChangeSet",
                "cloudformation:ExecuteChangeSet",
                "cloudformation:DeleteStack",
                "cloudformation:CreateStack",
                "cloudformation:GetTemplateSummary",
                "cloudformation:UpdateStack"
            ],
            "Resource": "*"
        },
        {
            "Sid": "S3Deploy",
            "Effect": "Allow",
            "Action": [
                "s3:CreateBucket",
                "s3:PutObject",
                "s3:ListBucket",
                "s3:PutBucketVersioning",
                "s3:GetObject",
                "s3:PutBucketPublicAccessBlock",
                "s3:DeleteBucket",
                "s3:PutBucketPolicy",
                "s3:DeleteBucketPolicy",
                "s3:GetBucketPolicy",
                "s3:DeleteObject"
            ],
            "Resource": "*"
        },
        {
            "Sid": "DynamoDBDeploy",
            "Effect": "Allow",
            "Action": [
                "dynamodb:DescribeTable",
                "dynamodb:DeleteTable",
                "dynamodb:CreateTable"
            ],
            "Resource": "*"
        },
        {
            "Sid": "CloudFrontDeploy",
            "Effect": "Allow",
            "Action": [
                "cloudfront:CreateOriginAccessControl",
                "cloudfront:GetOriginAccessControl",
                "cloudfront:UpdateOriginAccessControl",
                "cloudfront:DeleteOriginAccessControl",
                "cloudfront:CreateDistribution",
                "cloudfront:UpdateDistribution",
                "cloudfront:GetDistribution",
                "cloudfront:GetDistributionConfig",
                "cloudfront:DeleteDistribution",
                "cloudfront:TagResource",
                "cloudfront:UntagResource",
                "cloudfront:ListTagsForResource",
                "cloudfront:CreateInvalidation"
            ],
            "Resource": "*"
        },
        {
            "Sid": "IAMDeploy",
            "Effect": "Allow",
            "Action": [
                "iam:CreateRole",
                "iam:DeleteRolePolicy",
                "iam:PutRolePolicy",
                "iam:DetachRolePolicy",
                "iam:AttachRolePolicy",
                "iam:DeleteRole",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "iam:ListRolePolicies",
                "iam:ListAttachedRolePolicies",
                "iam:AttachRolePolicy",
                "iam:PutRolePolicy",
                "iam:DeleteRolePolicy",
                "iam:PassRole"
            ],
            "Resource": "*"
        },
        {
            "Sid": "APIGatewayDeploy",
            "Effect": "Allow",
            "Action": [
                "apigateway:POST",
                "apigateway:GET",
                "apigateway:DELETE",
                "apigateway:TagResource"
            ],
            "Resource": "*"
        },
        {
            "Sid": "LambdaDeploy",
            "Effect": "Allow",
            "Action": [
                "lambda:GetFunction",
                "lambda:DeleteFunction",
                "lambda:CreateFunction",
                "lambda:AddPermission",
                "lambda:RemovePermission"
            ],
            "Resource": "*"
        },
        {
            "Sid": "SNSDeploy",
            "Effect": "Allow",
            "Action": [
                "sns:CreateTopic",
                "sns:DeleteTopic",
                "sns:GetTopicAttributes",
                "sns:SetTopicAttributes",
                "sns:ListSubscriptionsByTopic",
                "sns:Subscribe",
                "sns:Unsubscribe",
                "sns:TagResource",
                "sns:UntagResource"
            ],
            "Resource": "*"
        },
        {
            "Sid": "CloudWatchDeploy",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricAlarm",
                "cloudwatch:DeleteAlarms",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:DescribeAlarmHistory",
                "cloudwatch:ListTagsForResource",
                "cloudwatch:TagResource",
                "cloudwatch:UntagResource"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Route53Deploy",
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets",
                "route53:ChangeTagsForResource",
                "route53:ListResourceRecordSets",
                "route53:GetHostedZone",
                "route53:ListTagsForResource",
                "route53:GetChange"
            ],
            "Resource": "*"
        },
        {
            "Sid": "ACMDeploy",
            "Effect": "Allow",
            "Action": [
                "acm:DescribeCertificate",
                "acm:ListTagsForCertificate"
            ],
            "Resource": "*"
        }
    ]
}
```