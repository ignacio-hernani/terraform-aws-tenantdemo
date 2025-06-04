# Terraform AWS Tenant Demo - Networking Infrastructure

This Terraform module creates a comprehensive networking infrastructure on AWS that includes IPAM, VPC, Security Groups, Transit Gateway, IAM Roles, and Resource Tags. It's designed to work with HashiCorp HCP Waypoint and uses HCP Vault Secrets to share networking details with compute workloads.

## Complete Solution

This repository contains:

1. **Networking Infrastructure Module** (root directory): Creates the base AWS networking infrastructure
3. **HCP Vault Secrets Integration**: Seamlessly connects networking and compute modules

## Architecture Components

### Networking Infrastructure
- **IPAM (IP Address Management)**: Manages IP address allocation across the infrastructure
- **VPC**: Creates a Virtual Private Cloud with public and private subnets
- **Security Groups**: Sets up base security rules for network access
- **Transit Gateway**: Enables network connectivity and routing
- **IAM Roles**: Creates necessary IAM roles for EC2 instances
- **Resource Tags**: Provides consistent tagging strategy

## HCP Vault Secrets Integration

This solution uses HCP Vault Secrets to create a seamless connection between networking infrastructure and compute workloads. The networking module automatically stores infrastructure details as secrets, which the VM add-on consumes.

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

## HCP Waypoint Integration

This solution is designed for **HCP Waypoint** deployment:

### Template Phase (Networking)
- Deploy as a **Waypoint Template**
- Creates networking infrastructure
- Populates HCP Vault Secrets automatically
- Provides foundation for compute workloads

### Add-On Phase (VMs)
- Deploy as a **Waypoint Add-On**
- Consumes secrets from networking template
- Creates EC2 instances in correct network configuration
- Inherits security and compliance settings

### Benefits
- **Separation of Concerns**: Network and compute deployed separately
- **Reusability**: Multiple add-ons can use the same networking infrastructure
- **Security**: All sensitive data managed via HCP Vault Secrets
- **Consistency**: Standardized networking across environments

## 📋 Prerequisites

1. **AWS Account**: With appropriate permissions
2. **HCP Account**: With Vault Secrets enabled
3. **HCP Service Principal**: For automated authentication
4. **Terraform**: Version >= 1.5.0
5. **Provider Versions**:
   - AWS provider ~> 5.99.0
   - HCP provider ~> 0.104.0

### HCP Authentication Setup

For **Waypoint/Terraform Cloud deployment**, create an HCP service principal:

1. **Create Service Principal** in HCP Console:
   - Go to **Access control (IAM)** → **Service principals**
   - Create with `secrets:app-secrets:admin` permission
   - Note the **Client ID** and **Client Secret**

2. **Configure Environment Variables** in Waypoint:
   ```bash
   HCP_CLIENT_ID="your-service-principal-client-id"
   HCP_CLIENT_SECRET="your-service-principal-client-secret"
   ```

3. **Alternative**: Use explicit variables:
   ```hcl
   hcp_client_id     = "your-client-id"
   hcp_client_secret = "your-client-secret"  # Mark as sensitive
   ```

## Module Dependencies

### External Modules Used
- `app.terraform.io/hashicorp-ignacio-test/ipam/aws`
- `app.terraform.io/hashicorp-ignacio-test/vpc/aws`
- `app.terraform.io/hashicorp-ignacio-test/security-groups/aws`
- `app.terraform.io/hashicorp-ignacio-test/resource-tags/aws`
- `app.terraform.io/hashicorp-ignacio-test/transit-gateway/aws`
- `app.terraform.io/hashicorp-ignacio-test/iam-roles/aws`
- `app.terraform.io/hashicorp-ignacio-test/ec2-instances/aws`

## Troubleshooting

### Common Issues

1. **"Secret not found"**: Ensure networking module is deployed first
2. **"Invalid HCP project"**: Verify HCP project ID and permissions
3. **"Module not found"**: Run `terraform init` to download modules
4. **"AWS access denied"**: Check AWS credentials and permissions

### Debug Commands

```bash
# Check networking secrets
terraform output hvs_secrets_available

# Verify VM connection to secrets
terraform output -module=vm_addon infrastructure_details

# List all secrets in HCP
hcp vault-secrets secrets list --app=<app-name>
```

---
