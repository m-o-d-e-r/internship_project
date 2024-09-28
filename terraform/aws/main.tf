terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  alias  = "eu-north-1"
  region = "eu-north-1"
}

provider "aws" {
  alias  = "eu-west-2"
  region = "eu-west-2"
}
