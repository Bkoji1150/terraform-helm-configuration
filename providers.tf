terraform {
  required_version = ">=1.1.5"

  backend "s3" {
    bucket         = "kojitechs.aws.eks.with.terraform.tf"
    dynamodb_table = "terraform-lock"
    key            = "helmconfiguration/path/env"
    region         = "us-east-1"
    encrypt        = "true"
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
    role_arn = "arn:aws:iam::${lookup(var.aws_account_id, terraform.workspace)}:role/Role_For-S3_Creation"
  }

}
