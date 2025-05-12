resource "aws_security_group" "webapp" {
    name   = "SG-WebApp"
    vpc_id = local.vpc_shared_id

    tags = {
        Name = "SG-WebApp"
    }
}

resource "aws_vpc_security_group_ingress_rule" "webapp_in_vpc" {
    security_group_id = aws_security_group.webapp.id
    cidr_ipv4         = local.vpc_shared_cidr
    ip_protocol       = "-1"
    
    tags = {
        Name = "IN_VPC"
    }
}

resource "aws_vpc_security_group_ingress_rule" "webapp_in_ssh" {
    security_group_id = aws_security_group.webapp.id
    cidr_ipv4         = "0.0.0.0/0"
    ip_protocol       = "tcp"
    from_port         = 22
    to_port           = 22
    
    tags = {
        Name = "IN_SSH"
    }
}

resource "aws_vpc_security_group_ingress_rule" "webapp_in_http" {
    security_group_id            = aws_security_group.webapp.id
    referenced_security_group_id = aws_security_group.elb.id
    ip_protocol                  = "tcp"
    from_port                    = 80
    to_port                      = 80
    
    tags = {
        Name = "IN_HTTP_FROM_ELB"
    }
}

resource "aws_vpc_security_group_egress_rule" "webapp_out_all" {
    security_group_id = aws_security_group.webapp.id
    cidr_ipv4         = "0.0.0.0/0"
    ip_protocol       = "-1"
    
    tags = {
        Name = "OUT_ALL"
    }
}

resource "aws_instance" "webapp" {
    ami                         = var.ec2_webapp["ami"]
    instance_type               = var.ec2_webapp["size"]
    subnet_id                   = local.subnet_pub1_id
    associate_public_ip_address = true
    vpc_security_group_ids      = [aws_security_group.webapp.id]
    key_name                    = var.ec2_webapp["key"]
    user_data                   = "${file("cust_webapp.sh")}"
    # iam_instance_profile        = aws_iam_instance_profile.gw.name

    tags = {
        Name = var.ec2_webapp["name"]
    }
}

resource "aws_lb_target_group" "webapp" {
    name        = "TG-WebApp"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = local.vpc_shared_id
  
    health_check {
        enabled  = true
        port     = 80
        protocol = "HTTP"
        path     = "/"
  }
}

resource "aws_lb_target_group_attachment" "webapp" {
    target_group_arn = aws_lb_target_group.webapp.arn
    target_id        = aws_instance.webapp.id
}

resource "aws_lb_listener_rule" "webapp" {
    listener_arn = aws_lb_listener.lstn_443.arn
    priority     = 10

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.webapp.arn
    }

    condition {
        host_header {
            values = ["webapp.aylab.cloud"]
        }
    }
}
