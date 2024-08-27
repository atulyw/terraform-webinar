resource "aws_security_group" "allow_tls" {
  name        = format("%s-%s-sg", var.namespace, var.env)
  description = var.description
  vpc_id      = var.vpc_id
  tags = merge(var.tags,{Name = format("%s-%s-sg", var.namespace, var.env)})
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
