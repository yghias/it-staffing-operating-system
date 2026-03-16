terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  tags = {
    Project     = var.service_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_log_group" "application" {
  name              = "/aws/ecs/${var.service_name}-${var.environment}"
  retention_in_days = 30
  tags              = local.tags
}

resource "aws_s3_bucket" "platform_data" {
  bucket = "${var.service_name}-${var.environment}-data"
  tags   = local.tags
}

resource "aws_db_subnet_group" "platform" {
  name       = "${var.service_name}-${var.environment}-db-subnets"
  subnet_ids = var.private_subnet_ids
  tags       = local.tags
}

resource "aws_db_instance" "postgres" {
  identifier             = "${var.service_name}-${var.environment}"
  engine                 = "postgres"
  engine_version         = "16.3"
  instance_class         = "db.t4g.medium"
  allocated_storage      = 100
  db_subnet_group_name   = aws_db_subnet_group.platform.name
  username               = "staffing_admin"
  password               = "replace-in-secrets-manager"
  skip_final_snapshot    = true
  publicly_accessible    = false
  deletion_protection    = false
  backup_retention_period = 7
  tags                   = local.tags
}

resource "aws_opensearch_domain" "talent_search" {
  domain_name    = "${var.service_name}-${var.environment}"
  engine_version = "OpenSearch_2.11"

  cluster_config {
    instance_type = "t3.small.search"
    instance_count = 1
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "gp3"
    volume_size = 30
  }

  tags = local.tags
}

resource "aws_scheduler_schedule_group" "workflows" {
  name = "${var.service_name}-${var.environment}"
  tags = local.tags
}
