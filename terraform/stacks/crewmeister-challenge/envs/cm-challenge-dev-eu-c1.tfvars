app_name       = "cm-challenge"
env            = "dev"
aws_region     = "eu-central-1"
vpc_cidr_block = "10.0.0.0/16"

#ECR
ecr_repo_name = "crewmeister-challenge"
# RDS
engine_version                         = "8.0"
instance_class                         = "db.t3.micro"
allocated_storage                      = 20
max_allocated_storage                  = 100
major_engine_version                   = "8.0"
family                                 = "mysql8.0"
backup_retention_period                = 30
backup_window                          = "03:00-06:00"
maintenance_window                     = "Mon:00:00-Mon:03:00"
cloudwatch_log_group_retention_in_days = 90
monitoring_interval                    = 30

