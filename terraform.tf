terraform {
  /* During VCS driven mode, the Terraform Cloud backend will be used to store the state file.
  cloud {
    organization = "Team_Tom"

    workspaces {
      name = "my_terraform_aws"
    }
  }
  */
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.48.0"
    }
  }

  required_version = ">= 1.1.0"
}