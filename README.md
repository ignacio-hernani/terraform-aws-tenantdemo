# Terraform AWS Tenant Demo - Networking Infrastructure

This Terraform module creates a comprehensive networking infrastructure on AWS that includes IPAM, VPC, Security Groups, Transit Gateway, IAM Roles, and Resource Tags. It's designed to work with HashiCorp HCP Waypoint and uses HCP Vault Secrets to share networking details with compute workloads.

## Architecture Components

- **IPAM (IP Address Management)**: Manages IP address allocation across the infrastructure
- **VPC**: Creates a Virtual Private Cloud with public and private subnets
- **Security Groups**: Sets up base security rules for network access
- **Transit Gateway**: Enables network connectivity and routing
- **IAM Roles**: Creates necessary IAM roles for EC2 instances
- **Resource Tags**: Provides consistent tagging strategy

## HCP Vault Secrets Integration

This module integrates with HCP Vault Secrets to store networking infrastructure details that can be consumed by VM modules or add-ons in HCP Waypoint. The following secrets are automatically created:

### Network Infrastructure Secrets
- `vpc_id`: The ID of the created VPC
- `vpc_cidr_block`: CIDR block of the VPC
- `private_subnet_ids`: Comma-separated list of private subnet IDs
- `public_subnet_ids`: Comma-separated list of public subnet IDs
- `all_subnet_ids`: Comma-separated list of all subnet IDs

### Security and Connectivity Secrets
- `base_security_group_id`: Base security group ID
- `app_security_group_id`: Application security group ID
- `transit_gateway_id`: Transit Gateway ID

### IAM and Resource Secrets
- `instance_role_name`: Name of the IAM instance role
- `instance_role_arn`: ARN of the IAM instance role
- `ipam_pool_id`: IPAM pool ID used for VPC allocation

### Environment Secrets
- `environment`: Environment name (dev, prod, etc.)
- `project_name`: Project name
- `aws_region`: AWS region
- `common_tags`: JSON-encoded common tags for resources

## Usage

### Required Variables

```hcl
# Required for HCP integration
waypoint_application = "your-waypoint-app-name"
ddr_user_hcp_project_resource_id = "your-hcp-project-id"
owner_email = "your-email@company.com"

# Optional overrides
environment = "dev"
project_name = "my-project"
aws_region = "us-east-1"
```

### Example Usage

```hcl
module "networking" {
  source = "./terraform-aws-tenantdemo"
  
  # HCP Configuration
  waypoint_application = "my-app"
  ddr_user_hcp_project_resource_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  owner_email = "admin@company.com"
  
  # Infrastructure Configuration
  environment = "dev"
  project_name = "demo-project"
  aws_region = "us-west-2"
  ipam_pool_cidr = "10.0.0.0/8"
  allowed_ssh_cidrs = ["10.0.0.0/8"]
}
```

## Consuming Secrets in VM Modules

Once this networking module is deployed, VM modules or add-ons can consume the secrets from HCP Vault Secrets:

```hcl
# Example: Reading VPC ID from HCP Vault Secrets
data "hcp_vault_secrets_secret" "vpc_id" {
  app_name    = var.waypoint_application
  secret_name = "vpc_id"
  project_id  = var.ddr_user_hcp_project_resource_id
}

# Use in EC2 instance
resource "aws_instance" "example" {
  subnet_id = split(",", data.hcp_vault_secrets_secret.private_subnet_ids.secret_value)[0]
  # ... other configuration
}
```

## Outputs

The module provides several outputs that can be used directly or are automatically stored in HCP Vault Secrets:

- `vpc_id`: VPC ID
- `private_subnet_ids`: Private subnet IDs
- `public_subnet_ids`: Public subnet IDs
- `hvs_app_name`: Name of the HCP Vault Secrets app
- `hvs_secrets_available`: List of available secrets

## Prerequisites

1. AWS credentials configured
2. HCP account with Vault Secrets enabled
3. Terraform >= 1.5.0
4. Required provider versions:
   - AWS provider ~> 5.0
   - HCP provider ~> 0.78

## Module Dependencies

This module uses the following external modules from the HashiCorp Terraform Cloud:

- `app.terraform.io/hashicorp-ignacio-test/ipam/aws`
- `app.terraform.io/hashicorp-ignacio-test/vpc/aws`
- `app.terraform.io/hashicorp-ignacio-test/security-groups/aws`
- `app.terraform.io/hashicorp-ignacio-test/resource-tags/aws`
- `app.terraform.io/hashicorp-ignacio-test/transit-gateway/aws`
- `app.terraform.io/hashicorp-ignacio-test/iam-roles/aws`

## Security Considerations

- All secrets are stored securely in HCP Vault Secrets
- IAM roles follow least privilege principles
- Security groups include necessary ingress rules for SSH, HTTP, and HTTPS
- Private subnets are used for backend resources 