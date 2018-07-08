#--------------------------------------------------------------
# <%= NAME %> - security group(s)
#--------------------------------------------------------------

#Create Security Group Definition
#--------------------------------------------------------------
resource "aws_security_group" "<%= NAME %>-sg" {
  name        = "${var.environment}.${var.<%= NAME %>_ec2_name}-sg"
  vpc_id      = "${var.vpc_id}"
  description = "${var.<%= NAME %>_ec2_name}-sg security group"

  tags {
    Name        = "${var.environment}.${var.<%= NAME %>_ec2_name}-sg"
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}

#Add rule to Security Group
resource "aws_security_group_rule" "<%= NAME %>-sg-rule-outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.<%= NAME %>-sg.id}"
}

#Add rule to Security Group
resource "aws_security_group_rule" "<%= NAME %>-sg-rule-icmp" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.<%= NAME %>-sg.id}"
}

#Add rule to Security Group
resource "aws_security_group_rule" "<%= NAME %>-sg-rule-http" {
  type              = "ingress"
  from_port         = <%= PORT %>
  to_port           = <%= PORT %>
  description       = "Access to the <%= NAME %>"
  protocol          = "tcp"
  source_security_group_id = "${aws_security_group.<%= NAME %>-alb-sg.id}"
  security_group_id = "${aws_security_group.<%= NAME %>-sg.id}"
}

#Add rule to Security Group
resource "aws_security_group_rule" "<%= NAME %>-sg-rule-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.<%= NAME %>-sg.id}"
}

#-------------------
# Outputs
#-------------------

output "<%= NAME %>_sg_id" {
  value = "${aws_security_group.<%= NAME %>-sg.id}"
}

#-------------------#
