
## KodeKloud AWS PhotoShare Labs (IaC version)

---
## Architecture Overview
<img width="1083" height="700" alt="Screenshot From 2026-02-28 15-53-08" src="https://github.com/user-attachments/assets/39025938-3b05-48e9-a176-e3e828fd9996" />
<br>link (Youtube): https://youtu.be/7eP8U2CnKdA?si=GaDDToWQF452dK7T

---
## What is about?
This is KodeKloud photoshare with two tier website which built the architecture AWS with Terraform based IaC. Kodekloud photoshare is website for upload image and store it to S3 also keep the metadata of that image to the RDS. Just simple web. The original tutorial is with AWS Console from beginning to end, because of that to make documentation is hard and also we cannot implementation CI/CD pipeline. This project is focused to build architecture use AWS - Terraform.

---
## Services Provisioned

| Module | AWS Service | Details |
|---|---|---|
| `vpc` | VPC | CIDR `10.0.0.0/16`, IGW, Route Table |
| `ec2` | EC2 | `t3.micro`, Amazon Linux 2023, Docker + Compose |
| `rds` | RDS MySQL | `db.t3.micro`, MySQL 8.4, private subnet, 20 GB gp3 |
| `s3` | S3 | AES-256 encrypted, fully private, photo asset storage |
| `alb` | ALB | Internet-facing, HTTP:80, health check at `/health` |
| `lambda` | Lambda | Python 3.13, triggered on `s3:ObjectCreated:*` events |
| `iam` | IAM | Separate roles for EC2 (S3 + Secrets) and Lambda (S3 + Logs) |
| `secretsmanager` | Secrets Manager | Stores DB credentials, injected into EC2 at boot |
| `cloudwatch` | CloudWatch | Dashboard (EC2 CPU + Lambda invocations) + Lambda error alarm |

### EC2 (`user_data.sh`)

On first launch, the EC2 instance:
- Installs Docker and Docker Compose via `dnf`
- Writes a `docker-compose.yml` that runs `kodekloud/photosharing-app` on port 80
- Writes a `.env` file with `S3_BUCKET` and `AWS_SECRET_NAME` (injected by Terraform)
- Starts the container with `docker-compose up -d`

The app fetches DB credentials at runtime by reading from **Secrets Manager** using the IAM role attached to the instance — no credentials are baked into the AMI.

---

## Project Structure

```
kodekloud-photoshare-architecture/
├── main.tf                   # Root module — wires all modules together
├── provider.tf               # AWS provider (us-east-1) + archive provider
├── variables.tf              # Input variables (subnets, DB creds, SSH key)
├── terraform.tfvars          # Default variable values (non-sensitive)
├── outputs.tf                # Outputs ALB DNS endpoint
├── src/
│   ├── index.py              # Lambda function — extracts S3 object metadata
│   └── user_data.sh          # EC2 bootstrap — installs Docker, runs the app
├── modules/
│   ├── alb/                  # Application Load Balancer + Target Group
│   ├── cloudwatch/           # Dashboard + metric alarm
│   ├── ec2/                  # EC2 instance + key pair + IAM profile
│   ├── iam/                  # IAM roles for EC2 and Lambda
│   ├── lambda/               # Lambda function + S3 trigger permission
│   ├── rds/                  # RDS MySQL instance + subnet group
│   ├── s3/                   # S3 bucket + encryption + public access block
│   ├── secretsmanager/       # Secret + secret version for DB credentials
│   └── vpc/                  # VPC + subnets + IGW + route table
└── .github/
    └── workflows/
        └── automate.yaml     # CI pipeline: fmt → validate → plan on push
```

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- AWS CLI configured with credentials that have sufficient permissions
- An SSH key pair (public key required for EC2 access)

---

## Getting Started

### 1. Clone the repository

```bash
git clone <your-repo-url>
cd kodekloud-photoshare-architecture
```

### 2. Create the secrets file

Create a file named `secrets.tfvars` (this file is gitignored — do **not** commit it):

```hcl
database_username = "<your-db-username>"
database_password = "<your-db-password>"
pub_key           = "<your-ssh-public-key>"
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Plan and apply

```bash
terraform plan -var-file=secrets.tfvars
terraform apply -var-file=secrets.tfvars -auto-approve
```

### 5. Access the application

After apply completes, Terraform outputs the ALB DNS endpoint:

```
Outputs:
alb_dns = "http://<alb-dns-name>.us-east-1.elb.amazonaws.com"
```

Open the URL in your browser. The EC2 instance takes ~1–2 minutes to finish the Docker startup before the app is reachable.

### 6. Destroy resources

```bash
terraform destroy -var-file=secrets.tfvars -auto-approve
```

---

## How It Works

### Photo Upload Flow

1. A user uploads a photo via the web app → file stored in **S3**.
2. S3 `ObjectCreated` event triggers the **Lambda** function (`photoshare-metadata-extractor`).
3. Lambda calls `s3:HeadObject` to get file size and MIME type, then POSTs the metadata as JSON to `http://<ALB>/api/webhook`.
4. The web app receives the webhook and stores the metadata in **RDS MySQL**.
