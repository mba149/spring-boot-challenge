module "db_kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "3.1.1"

  aliases                 = ["${local.name}-MYSQL"]
  deletion_window_in_days = var.kms_deletion_window_in_days
  description             = "KMS key for MYSQL RDS"
  enable_key_rotation     = true
  key_owners              = [local.current_identity]
  multi_region            = false

  tags = {
    Name = "${local.name}-mysql"
  }
}

module "db_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"

  name        = "${local.name}-db-sg"
  description = "MYSQL security group"
  vpc_id      = module.vpc.vpc_id
}

module "db_security_group_rule" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"

  create_sg         = false
  security_group_id = module.db_security_group.security_group_id

  ingress_with_source_security_group_id = [
    {
      description              = "Allow access from EKS"
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      source_security_group_id = module.eks.node_security_group_id
    }
  ]
}

module "mysql" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.10.0"

  create_db_instance = true
  identifier         = "${local.name}-mysql"

  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  vpc_security_group_ids = [module.db_security_group.security_group_id]
  multi_az               = var.multi_az

  # Storage
  max_allocated_storage = var.max_allocated_storage
  allocated_storage     = var.allocated_storage
  storage_encrypted     = var.storage_encrypted

  # DB option group
  create_db_option_group = var.create_db_option_group
  major_engine_version   = var.major_engine_version

  # DB parameter group
  create_db_parameter_group = var.create_db_parameter_group
  family                    = var.family

  # DB subnet group
  create_db_subnet_group = var.create_db_subnet_group
  subnet_ids             = module.vpc.database_subnets

  # DB updates
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade

  # Backup
  backup_retention_period  = var.backup_retention_period
  backup_window            = var.backup_window
  delete_automated_backups = var.delete_automated_backups

  # Authentication
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  manage_master_user_password         = true

  # Maintenance
  maintenance_window = var.maintenance_window

  # CloudWatch logs
  enabled_cloudwatch_logs_exports        = var.enabled_cloudwatch_logs_exports
  create_cloudwatch_log_group            = var.create_cloudwatch_log_group
  cloudwatch_log_group_class             = var.cloudwatch_log_group_class
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days

  # Database Deletion Protection
  deletion_protection = var.deletion_protection

  # KMS
  kms_key_id = module.db_kms.key_arn

  # Enhanced Monitoring
  create_monitoring_role = var.create_monitoring_role
  monitoring_interval    = var.monitoring_interval
  monitoring_role_name   = var.monitoring_role_name

  # Database
  db_name  = var.db_name
  username = "root"

  tags = local.tags

}
