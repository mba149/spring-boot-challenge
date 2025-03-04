aws_region = "eu-central-1"

s3_bucket_name = "cm-challenge-dev-eu-c1-state"

tags = {
  name        = "cm-challenge-dev-eu-c1"
  environment = "dev"
}

dynamodb_table_name = "cm-challenge-dev-eu-c1-terraform-lock"

aws_sso_profile = "cm-challenge-dev-eu-c1"