resource "aws_security_group" "photoshare_ec2_securitygroup" {
  name        = var.ec2_securitygroup_name
  description = "Security Group for Web Server"
  vpc_id      = var.vpc_id

  tags = {
    Name = var.ec2_securitygroup_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "photoshare_ec2_securitygroup_allow_http" {
  security_group_id            = aws_security_group.photoshare_ec2_securitygroup.id
  referenced_security_group_id = var.alb_securitygroup_id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

resource "aws_vpc_security_group_ingress_rule" "photoshare_ec2_securitygroup_allow_ssh" {
  security_group_id = aws_security_group.photoshare_ec2_securitygroup.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "photoshare_ec2_securitygroup_allow_egress_ec2" {
  security_group_id = aws_security_group.photoshare_ec2_securitygroup.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
