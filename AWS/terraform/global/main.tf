terraform {
  required_providers {
    awsutils = {
      source = "cloudposse/awsutils"
    }
  }
}

provider "aws" {
    region = var.aws["region"]
}

provider "awsutils" {
    region = var.aws["region"]
}

resource "awsutils_default_vpc_deletion" "default" {
}
