variable "aws_region" {
  type        = string
  description = "AWS region for platform resources."
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Deployment environment name."
  default     = "dev"
}

variable "service_name" {
  type        = string
  description = "Base name for platform resources."
  default     = "it-staffing-operating-system"
}

variable "vpc_id" {
  type        = string
  description = "Existing VPC for managed services."
  default     = "vpc-override"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets for database and compute."
  default     = ["subnet-a", "subnet-b"]
}
