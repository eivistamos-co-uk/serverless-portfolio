# CI/CD Pipeline

- GitHub Actions workflow added in `.github/workflows/deploy.yml`.
- Secrets stored in GitHub Actions Secrets for security.
- On each push to `main`:
  1. Runs lint job to check and validate the CloudFormation infrastructure templates
  2. Runs package job to:
    - Create Template bucket if missing.
    - Upload infrastructure templates and lambda code to bucket.
  3. Runs deploy job to:
    - Deploy infrastrucutre using the main.yaml file.
    - Prepare the API URL to be used for the visitor counter.
    - Sync site files (HTML/CSS/JS) to S3 bucket.
    - Invalidate CloudFront cache to show up to date site files.

