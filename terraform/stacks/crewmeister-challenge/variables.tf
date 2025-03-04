variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "env" {
  description = "Environment of the App"
  type        = string
}

variable "app_name" {
  description = "Name of the app"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}
#ECR
variable "ecr_repo_name" {
  description = "Name of the ECR repo"
  type        = string
}

#KMS
variable "kms_deletion_window_in_days" {
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key."
  type        = number
  default     = 30
}

# RDS
variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
}

variable "max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling"
  type        = number
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = true
}

variable "create_db_option_group" {
  description = "Whether to create a database option group"
  type        = bool
  default     = true
}

variable "major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with"
  type        = string
}

variable "create_db_parameter_group" {
  description = "Whether to create a database parameter group"
  type        = bool
  default     = true
}

variable "family" {
  description = "The family of the DB parameter group"
  type        = string
}

variable "create_db_subnet_group" {
  description = "Whether to create a database subnet group"
  type        = bool
  default     = true
}

variable "allow_major_version_upgrade" {
  description = " Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
}

variable "delete_automated_backups" {
  description = "Specifies whether to delete automated backups immediately after the DB instance is deleted"
  type        = bool
  default     = false
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether to enable IAM database authentication"
  type        = bool
  default     = false
}

variable "maintenance_window" {
  description = "The window to perform maintenance in"
  type        = string
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to CloudWatch"
  type        = list(string)
  default     = ["general"]
}

variable "create_cloudwatch_log_group" {
  description = "Specifies whether to create CloudWatch log group"
  type        = bool
  default     = true
}

variable "cloudwatch_log_group_class" {
  description = "The class of the CloudWatch log group"
  type        = string
  default     = "STANDARD"
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "The number of days to retain logs in CloudWatch log group"
  type        = number
}

variable "deletion_protection" {
  description = "Specifies whether to enable deletion protection"
  type        = bool
  default     = false
}

variable "create_monitoring_role" {
  description = "Specifies whether to create an IAM role for enhanced monitoring"
  type        = bool
  default     = true
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between Enhanced Monitoring metrics"
  type        = number
}

variable "monitoring_role_name" {
  description = "Name of the IAM role for enhanced monitoring"
  type        = string
  default     = "mysql-monitoring-role"
}

variable "db_name" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
  default     = "crewneisterchallenge"
}
