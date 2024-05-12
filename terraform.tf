terraform {

  cloud {
    organization = "Team_Tom"

    workspaces {
      name = "my_terraform_aws"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.48.0"
    }
  }

  required_version = ">= 1.1.0"
}