# HCP Vault Secrets App for Waypoint application
resource "hcp_vault_secrets_app" "hvs_app" {
  app_name    = var.waypoint_application
  description = "HCP Vault Secrets for Waypoint application ${var.waypoint_application}"
  project_id  = var.ddr_user_hcp_project_resource_id
}

locals {
  all_secrets = {
    # Networking infrastructure details
    vpc_id             = module.vpc.vpc_id
    vpc_cidr_block     = module.vpc.vpc_cidr_block
    private_subnet_ids = join(",", module.vpc.private_subnet_ids)
    public_subnet_ids  = join(",", module.vpc.public_subnet_ids)
    all_subnet_ids     = join(",", module.vpc.subnet_ids)

    # Security Groups
    base_security_group_id = module.security_groups.base_sg_id
    app_security_group_id  = module.security_groups.app_sg_id

    # Transit Gateway
    transit_gateway_id = module.transit_gateway.tgw_id

    # IAM Role information
    instance_role_name = module.iam_roles.instance_role_name
    instance_role_arn  = module.iam_roles.instance_role_arn

    # IPAM details
    ipam_pool_id = module.ipam.vpc_ipam_pool_id

    # Environment details
    environment  = var.environment
    project_name = var.project_name
    aws_region   = var.aws_region

    # Common tags as JSON string for easy consumption
    common_tags = jsonencode(local.common_tags)
  }
}

# Create secrets for each key-value pair
resource "hcp_vault_secrets_secret" "this" {
  for_each = local.all_secrets

  app_name     = hcp_vault_secrets_app.hvs_app.app_name
  secret_name  = each.key
  secret_value = each.value
  project_id   = var.ddr_user_hcp_project_resource_id
}
