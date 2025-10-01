# Infrastructure Refactor

- Split single template into 5 nested stacks:
  - networking.yaml
  - frontend.yaml
  - backend.yaml
  - database.yaml
  - monitoring.yaml
- Parent `main.yaml` references them using S3 URLs in deployed templates bucket.
- Automated upload + deploy with `.github\workflows\deploy.yml`