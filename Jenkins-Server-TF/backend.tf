terraform {
  backend "s3" {
    bucket         = "devops-terraform-state-bucket-us-east-1"
    region         = "us-east-1"
    key            = "Kubernetes-Three-Tier-Project/Jenkins-Server-TF/terraform.tfstate"
    dynamodb_table = "LOCK-Files"
    encrypt        = true
  }
  required_version = ">=0.13.0"
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
}