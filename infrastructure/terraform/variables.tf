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
