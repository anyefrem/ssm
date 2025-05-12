provider "aws" {
    region = var.aws["region"]
}

resource "aws_vpc" "shared" {
    cidr_block           = var.vpc["cidr"]
    enable_dns_hostnames = false
    
    tags                 = {
        Name             = var.vpc["name"]
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id   = aws_vpc.shared.id
    
    tags     = {
        Name = var.vpc["igw"]
    }
}

resource "aws_subnet" "pub1" {
    vpc_id            = aws_vpc.shared.id
    cidr_block        = var.vpc["subnets"]["pub1"]["cidr"]
    availability_zone = var.vpc["subnets"]["pub1"]["az"]
    
    tags              = {
        Name          = var.vpc["subnets"]["pub1"]["name"]
    }
}

resource "aws_subnet" "pub2" {
    vpc_id            = aws_vpc.shared.id
    cidr_block        = var.vpc["subnets"]["pub2"]["cidr"]
    availability_zone = var.vpc["subnets"]["pub2"]["az"]
    
    tags              = {
        Name          = var.vpc["subnets"]["pub2"]["name"]
    }
}

resource "aws_route_table" "rtb_pub" {
    vpc_id         = aws_vpc.shared.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    
    tags           = {
        Name       = var.vpc.rtb.pub["name"]
    }
}

resource "aws_route_table_association" "pub1" {
    subnet_id      = aws_subnet.pub1.id
    route_table_id = aws_route_table.rtb_pub.id
}

resource "aws_route_table_association" "pub2" {
    subnet_id      = aws_subnet.pub2.id
    route_table_id = aws_route_table.rtb_pub.id
}

# resource "aws_subnet" "priv1" {
#     vpc_id            = aws_vpc.shared.id
#     cidr_block        = var.vpc["subnets"]["priv1"]["cidr"]
#     availability_zone = var.vpc["subnets"]["priv1"]["az"]
#     tags              = {
#         Name          = var.vpc["subnets"]["priv1"]["name"]
#     }
# }

# resource "aws_default_route_table" "rtb_priv" {
#     default_route_table_id   = aws_vpc.shared.default_route_table_id
#     route {
#         cidr_block           = "0.0.0.0/0"
#         network_interface_id = aws_instance.gw.primary_network_interface_id
#     }
#     tags                     = {
#         Name                 = var.vpc.rtb.priv["name"]
#     }
# }

# resource "aws_route_table_association" "priv1" {
#     subnet_id      = aws_subnet.priv1.id
#     route_table_id = aws_default_route_table.rtb_priv.id
# }

output "vpc_shared_id" {
    value = aws_vpc.shared.id
}

output "vpc_shared_cidr" {
    value = aws_vpc.shared.cidr_block
}

output "subnet_pub1_id" {
    value = aws_subnet.pub1.id
}

output "subnet_pub2_id" {
    value = aws_subnet.pub2.id
}
