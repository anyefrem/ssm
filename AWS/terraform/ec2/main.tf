provider "aws" {
    region = var.aws["region"]
}

resource "aws_security_group" "elb" {
    name   = "SG-ELB"
    vpc_id = local.vpc_shared_id

    tags = {
        Name = "SG-ELB"
    }
}

resource "aws_vpc_security_group_ingress_rule" "elb_in_http" {
    security_group_id = aws_security_group.elb.id
    cidr_ipv4   = "0.0.0.0/0"
    ip_protocol = "tcp"
    from_port   = 80
    to_port     = 80
    
    tags = {
        Name = "IN_HTTP"
    }
}

resource "aws_vpc_security_group_ingress_rule" "elb_in_https" {
    security_group_id = aws_security_group.elb.id
    cidr_ipv4   = "0.0.0.0/0"
    ip_protocol = "tcp"
    from_port   = 443
    to_port     = 443
    
    tags = {
        Name = "IN_HTTPS"
    }
}

resource "aws_vpc_security_group_egress_rule" "elb_out_all" {
    security_group_id = aws_security_group.elb.id
    cidr_ipv4         = "0.0.0.0/0"
    ip_protocol       = "-1"
    
    tags = {
        Name = "OUT_ALL"
    }
}

resource "aws_lb" "elb" {
    name               = var.elb["name"]
    load_balancer_type = "application"
    security_groups    = [aws_security_group.elb.id]
    subnets            = [local.subnet_pub1_id, local.subnet_pub2_id]
}

resource "aws_lb_listener" "lstn_443" {
    load_balancer_arn = aws_lb.elb.arn
    port              = "443"
    protocol          = "HTTPS"
    ssl_policy        = var.elb["ssl_policy"]
    certificate_arn   = var.elb["cert_arn"]

    default_action {
        type             = "fixed-response"
        fixed_response {
            content_type = "text/plain"
            message_body = "aylab.cloud"
            status_code  = "200"
        }
    }
}
