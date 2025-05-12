data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../vpc/terraform.tfstate"
  }
}

locals {
  vpc_shared_id = data.terraform_remote_state.vpc.outputs.vpc_shared_id
  vpc_shared_cidr = data.terraform_remote_state.vpc.outputs.vpc_shared_cidr
  subnet_pub1_id = data.terraform_remote_state.vpc.outputs.subnet_pub1_id
  subnet_pub2_id = data.terraform_remote_state.vpc.outputs.subnet_pub2_id
}

variable "aws" {
    type = any
    default = {
        region = "eu-north-1"
    }
}

variable elb {
    type           = any
    default        = {
        name       = "AYLAB"
        ssl_policy = "ELBSecurityPolicy-2016-08"
        cert_arn   = "arn:aws:acm:eu-north-1:761734873168:certificate/2f7b6127-ee04-4034-b8ce-998e2c64b9b0"
    }
}

variable ec2_webapp {
    type           = any
    default        = {
        name       = "WebApp"
        ami        = "ami-0c1ac8a41498c1a9c"
        size       = "t3.micro"
        key        = "aylab"
    }
}
