# CI/CD Pipeline

- GitHub Actions workflow added in `.github/workflows/deploy.yml`.
- On each push to `main`:
  1. Uploads nested stack templates to backend(templates/lambda) bucket.
  2. Deploys CloudFormation main.yaml stack.
  3. Syncs frontend(site) files to S3 site bucket.
- Secrets stored in GitHub Actions Secrets for security.
