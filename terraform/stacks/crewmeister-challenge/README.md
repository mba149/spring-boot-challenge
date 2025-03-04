# Terraform
This Terraform configuration sets up an AWS EKS cluster with supporting infrastructure, including VPC, RDS, ECR, and other necessary components. The deployment includes managed node groups, IAM roles, and Helm deployments for additional functionality.

## Prerequisites
Ensure you have the following installed and configured:
<ul>
  <li>Terraform</li>
  <li>AWS CLI</li>
  <li>AWS Credentials Configured</li>
  <li>Helm</li>
</ul>

## Providers
| Name  | Version  |
|---|---|
| AWS  |  ~> 5.0 |
| Helm  | 2.17.0 |

## Resources
<ul>
  <li>EKS</li>
  <li>RDS (MySQL)</li>
  <li>VPC</li>
  <li>ECR</li>
  <li>External Secrets</li>
  <li>ALB Controller</li>
</ul>

## Deployment Instructions
### Initialize Terraform
`terraform init`
###  Plan the Deployment
`terraform plan -var-file=envs/cm-challenge-dev-eu-c1.tfvars`
###  Apply Configurations
`terraform apply -var-file=envs/cm-challenge-dev-eu-c1.tfvars  `

