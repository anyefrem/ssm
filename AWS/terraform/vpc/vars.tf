variable "aws" {
    type = any
    default = {
        region = "eu-north-1"
    }
}

variable "vpc" {
    type             = any
    default          = {
        name         = "Shared"
        cidr         = "10.227.0.0/16"
        igw          = "IGW"
        subnets      = {
            pub1     = {
                name = "Public1"
                cidr = "10.227.10.0/24"
                az   = "eu-north-1a"
            }
            pub2     = {
                name = "Public2"
                cidr = "10.227.20.0/24"
                az   = "eu-north-1b"
            }
            priv1    = {
                name = "Private1"
                cidr = "10.227.100.0/24"
                az   = "eu-north-1a"
            }
        }
        rtb          = {
            pub      = {
                name = "RtbPub"
            }
            priv     = {
                name = "RtbPriv"
            }
        }
    }
}
