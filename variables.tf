variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "rfp-poc"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ipam_pool_cidr" {
  description = "IPAM pool CIDR for dynamic allocation"
  type        = string
  default     = "10.0.0.0/8"
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cost_center" {
  description = "Cost center for billing"
  type        = string
  default     = "engineering"
}

variable "owner_email" {
  description = "Owner email for notifications"
  type        = string
}

# HCP and Waypoint Configuration Variables
variable "waypoint_application" {
  description = "Waypoint application name"
  type        = string
}

variable "ddr_user_hcp_project_resource_id" {
  description = "HCP project resource ID for the user"
  type        = string
}

# Optional HCP Authentication (if not using environment variables)
variable "hcp_client_id" {
  description = "HCP service principal client ID (optional if using env vars)"
  type        = string
  default     = null
  sensitive   = true
}

variable "hcp_client_secret" {
  description = "HCP service principal client secret (optional if using env vars)"
  type        = string
  default     = null
  sensitive   = true
}
