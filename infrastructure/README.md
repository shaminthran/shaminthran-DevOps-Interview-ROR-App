# DevOps Interview Ruby on Rails App - AWS ECS Deployment (Terraform + GitHub Actions)

This repository demonstrates the end-to-end CI/CD deployment of a **Ruby on Rails web application** using **AWS ECS Fargate**, **Terraform**, and **GitHub Actions**. 
It adheres to best DevOps and infrastructure-as-code practices by provisioning a scalable, secure, and modular AWS infrastructure.

## Tech Stack

- **Application**: Ruby on Rails
- **Containerization**: Docker
- **Infrastructure**: Terraform
- **Orchestration**: AWS ECS (Fargate)
- **CI/CD**: GitHub Actions
- **Storage**: AWS S3
- **Database**: AWS RDS (PostgreSQL)
- **Networking**: VPC with private/public subnets, ALB, NAT
- **IAM**: IAM Role-based S3 access

### Key AWS Resources Deployed
- **VPC** with public and private subnets across 2 AZs
- **Internet Gateway** and **NAT Gateway** for routing
- **S3 Bucket** to store file uploads
- **RDS (PostgreSQL)** in private subnets
- **ECS Cluster (Fargate)** with 1 Task running the Rails container
- **Application Load Balancer (ALB)** in public subnet forwarding to private ECS service
- **IAM Role** to allow ECS access to pull images and interact with S3

## CI/CD Pipeline (GitHub Actions)

### Trigger
- Runs on every `push` to the `main` branch.

### Steps
1. **Checkout** the code from GitHub.
2. **Configure AWS credentials** via GitHub Secrets.
3. **Login to ECR** using AWS Actions.
4. **Build Docker image** from `docker/app/Dockerfile`.
5. **Push image** to ECR repository: `ror-app-repo`.
6. **Initialize and apply Terraform** inside the `infrastructure/` folder to deploy/update AWS infrastructure and ECS service.

GitHub Secrets used:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

## Deployment Output

After successful deployment, Terraform outputs:
-  **ALB DNS Name**: Used to access the Rails application
-  All components (RDS, ECS, S3) are provisioned and connected
-  Rails app runs behind an ALB, with static assets and uploads handled via S3


## Environment Variables (Injected into ECS Task)

| Variable Name      | Description                        |
|--------------------|------------------------------------|
| RDS_DB_NAME        | PostgreSQL DB name                 |
| RDS_USERNAME       | PostgreSQL DB user                 |
| RDS_PASSWORD       | PostgreSQL DB password             |
| RDS_HOSTNAME       | DB instance hostname               |
| RDS_PORT           | PostgreSQL port                    |
| S3_BUCKET_NAME     | S3 bucket name                     |
| S3_REGION_NAME     | S3 region                          |
| LB_ENDPOINT        | ALB DNS name for app access        |

##  How to Deploy (From Scratch)

1. **Fork this repo** into your own GitHub account.
2. **Set GitHub Secrets**:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
3. **Push any changes** to the `main` branch to trigger CI/CD.
4. **Wait for GitHub Actions** to complete:
   - Image is built and pushed to ECR.
   - Terraform provisions the infrastructure.
   - ECS service is updated with the new image.
5. **Access the app** via the Load Balancer DNS (Terraform output).

##  Testing the Application

1. Open the DNS from `load_balancer_dns` output in a browser.
2. Confirm Rails app loads.
3. Test file upload (uses S3).
4. Confirm database-backed pages load (connected to RDS).

##  Clean Up

To delete all resources created by Terraform:
```bash
cd infrastructure
terraform destroy


