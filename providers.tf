
terraform {

  backend "s3" {
    bucket         = "non-prod-nggf-terraform-state-us-east-1-179630400142"
    key            = "lab/awsuse1/helmdeployk8s/enhancement/gheorchestration.tfstate"
    region         = "us-east-1"
    dynamodb_table = "lab-awsuse1-tflocks"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::179630400142:role/travelport-AWSManagedServicesDevelopmentRole"
  }
}
