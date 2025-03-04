module "ecr_kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "3.1.1"

  aliases                 = ["${local.name}-ecr"]
  deletion_window_in_days = var.kms_deletion_window_in_days
  description             = "KMS key for ECR"
  enable_key_rotation     = true
  key_owners              = [local.current_identity]
  multi_region            = false

  tags = {
    Name = "${local.name}-ecr"
  }
}

module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.3.0"

  repository_name = var.ecr_repo_name

  repository_image_scan_on_push   = true
  repository_encryption_type      = "KMS"
  repository_kms_key              = module.ecr_kms.key_arn
  create_lifecycle_policy         = true
  repository_image_tag_mutability = "MUTABLE"

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus   = "any",
          countType   = "imageCountMoreThan",
          countNumber = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# IAM Policy for ECR Access
resource "aws_iam_policy" "eks_ecr_access_policy" {
  name        = "${local.name}-ecr-access-policy"
  description = "Policy to allow EKS to access ECR"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "ecr:GetAuthorizationToken",
        ],
        Resource : "*"
      },
      {
        Effect : "Allow",
        Action : [
          "ecr:DescribeImages",
          "ecr:ListImages",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ],
        Resource : [
          module.ecr.repository_arn
        ]
      }
    ]
  })
}
