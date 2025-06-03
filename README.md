# Terraform AWS Tenant Demo - Networking Infrastructure

This Terraform module creates a comprehensive networking infrastructure on AWS that includes IPAM, VPC, Security Groups, Transit Gateway, IAM Roles, and Resource Tags. It's designed to work with HashiCorp HCP Waypoint and uses HCP Vault Secrets to share networking details with compute workloads.

## 🏗️ Complete Solution

This repository contains:

1. **Networking Infrastructure Module** (root directory): Creates the base AWS networking infrastructure
2. **VM Add-On Module** (`/vm-addon`): Consumes networking details to create EC2 instances
3. **HCP Vault Secrets Integration**: Seamlessly connects networking and compute modules

## 🔧 Architecture Components

### Networking Infrastructure
- **IPAM (IP Address Management)**: Manages IP address allocation across the infrastructure
- **VPC**: Creates a Virtual Private Cloud with public and private subnets
- **Security Groups**: Sets up base security rules for network access
- **Transit Gateway**: Enables network connectivity and routing
- **IAM Roles**: Creates necessary IAM roles for EC2 instances
- **Resource Tags**: Provides consistent tagging strategy

### VM Add-On
- **EC2 Instances**: Creates configurable EC2 instances in the network infrastructure
- **SSH Key Management**: Generates and manages SSH key pairs
- **Automatic Configuration**: Uses networking details from HCP Vault Secrets
- **Security Integration**: Inherits security groups and IAM roles from networking module

## 🔐 HCP Vault Secrets Integration

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

## 🚀 Quick Start

### 1. Deploy Networking Infrastructure

```hcl
module "networking" {
  source = "./terraform-aws-tenantdemo"
  
  # HCP Configuration
  waypoint_application = "my-app"
  ddr_user_hcp_project_resource_id = "your-hcp-project-id"
  owner_email = "admin@company.com"
  
  # Infrastructure Configuration
  environment = "dev"
  project_name = "demo-project"
  aws_region = "us-west-2"
}
```

### 2. Deploy VM Add-On

```hcl
module "vm_addon" {
  source = "./terraform-aws-tenantdemo/vm-addon"
  
  # HCP Configuration (MUST match networking module)
  waypoint_application = "my-app"
  ddr_user_hcp_project_resource_id = "your-hcp-project-id"
  
  # VM Configuration
  instance_types = {
    flavor1 = "t3.micro"
    flavor2 = "t3.small"
  }
}
```

### 3. Complete Example

See `example-usage.tf` for a complete working example that deploys both modules together.

## 📁 Repository Structure

```
terraform-aws-tenantdemo/
├── main.tf                    # Networking infrastructure
├── hvs.tf                     # HCP Vault Secrets integration
├── variables.tf               # Networking variables
├── outputs.tf                 # Networking outputs
├── README.md                  # This file
├── example-usage.tf           # Complete usage example
└── vm-addon/                  # VM Add-On Module
    ├── main.tf                # VM infrastructure
    ├── variables.tf           # VM variables
    ├── outputs.tf             # VM outputs
    └── README.md              # VM add-on documentation
```

## 🎯 HCP Waypoint Integration

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

## 🔑 Required Variables

### For Networking Module
```hcl
# Required
waypoint_application = "your-waypoint-app-name"
ddr_user_hcp_project_resource_id = "your-hcp-project-id"
owner_email = "your-email@company.com"

# Optional with defaults
environment = "dev"
project_name = "demo-project"
aws_region = "us-east-1"
```

### For VM Add-On
```hcl
# Required (must match networking module)
waypoint_application = "your-waypoint-app-name"
ddr_user_hcp_project_resource_id = "your-hcp-project-id"

# Optional with defaults
instance_types = {
  flavor1 = "t3.micro"
  flavor2 = "t3.small"
}
```

## 📊 Outputs

### Networking Module
- `vpc_id`: VPC ID
- `private_subnet_ids`: Private subnet IDs  
- `public_subnet_ids`: Public subnet IDs
- `hvs_app_name`: HCP Vault Secrets app name
- `hvs_secrets_available`: List of available secrets

### VM Add-On
- `instance_ids`: EC2 instance IDs
- `instance_private_ips`: Private IP addresses
- `ssh_connection_helper`: SSH connection guidance
- `infrastructure_details`: Retrieved infrastructure info

## 🔒 Security Features

- **HCP Vault Secrets**: All infrastructure details stored securely
- **IAM Integration**: Least privilege access patterns
- **Network Isolation**: Private/public subnet separation
- **Security Groups**: Pre-configured application access rules
- **SSH Key Management**: Automated key generation and management

## 📋 Prerequisites

1. **AWS Account**: With appropriate permissions
2. **HCP Account**: With Vault Secrets enabled
3. **Terraform**: Version >= 1.5.0
4. **Provider Versions**:
   - AWS provider ~> 5.99.0
   - HCP provider ~> 0.104.0

## 🔧 Module Dependencies

### External Modules Used
- `app.terraform.io/hashicorp-ignacio-test/ipam/aws`
- `app.terraform.io/hashicorp-ignacio-test/vpc/aws`
- `app.terraform.io/hashicorp-ignacio-test/security-groups/aws`
- `app.terraform.io/hashicorp-ignacio-test/resource-tags/aws`
- `app.terraform.io/hashicorp-ignacio-test/transit-gateway/aws`
- `app.terraform.io/hashicorp-ignacio-test/iam-roles/aws`
- `app.terraform.io/hashicorp-ignacio-test/ec2-instances/aws`

## 🔍 Troubleshooting

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

## 🤝 Contributing

This is a demo repository for HashiCorp HCP Waypoint integration. For issues or improvements, please contact the HashiCorp demo engineering team.

---

**🎉 Ready for your HCP Waypoint demo!** This solution provides a complete networking foundation with seamless VM integration via HCP Vault Secrets. 