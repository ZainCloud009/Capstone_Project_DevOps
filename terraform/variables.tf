variable "aws_region" {
  description = "AWS Region for deployment"
  type        = string
  default     = "eu-north-1"
}

variable "domain_name" {
  description = "Domain name for existing ACM Certificate"
  type        = string
  default     = "iamzain.space"
}

variable "key_name" {
  description = "Name of existing EC2 Key Pair (without .pem extension)"
  type        = string
  default     = "testingserver"
}

variable "ecr_repository_name" {
  description = "Name of the AWS ECR repository"
  type        = string
  default     = "capstoneprojrepo"
}

# ==============================================================================
# EXISTING SECURITY GROUPS
# ==============================================================================

variable "ec2_security_group_id" {
  description = "Existing Security Group ID for EC2 instances (EC2 Capstone Proj)"
  type        = string
  default     = "sg-0c6135b6b87b56318"
}

variable "alb_security_group_id" {
  description = "Existing Security Group ID for ALB (ALB Capstone Proj)"
  type        = string
  default     = "sg-0e7c28c370e7f6020"
}

variable "rds_security_group_id" {
  description = "Existing Security Group ID for RDS MySQL (RDS Capstone Proj)"
  type        = string
  default     = "sg-044e01cabc894f815"
}

# ==============================================================================
# DATABASE CONFIGURATION
# ==============================================================================

variable "db_name" {
  description = "MySQL database name"
  type        = string
  default     = "idea"
}

variable "db_username" {
  description = "MySQL master username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "MySQL master password"
  type        = string
  default     = "RootPassword123!"
  sensitive   = true
}
