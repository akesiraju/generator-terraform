#--------------------------------------------------------------
# <%= NAME %> - security group(s)
#--------------------------------------------------------------

#Create Security Group Definition
#--------------------------------------------------------------
resource "aws_security_group" "<%= NAME %>-alb-sg" {
  name        = "${var.environment}.${var.<%= NAME %>_ec2_name}-alb-sg"
  vpc_id      = "${var.vpc_id}"
  description = "${var.<%= NAME %>_ec2_name}-alb-sg security group"

  tags {
    Name        = "${var.environment}.${var.<%= NAME %>_ec2_name}-alb-sg"
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}

#Add rule to Security Group
resource "aws_security_group_rule" "<%= NAME %>-alb-sg-rule-outbound" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.<%= NAME %>-alb-sg.id}"
}

#Add rule to Security Group
resource "aws_security_group_rule" "<%= NAME %>-alb-sg-rule-http" {
  type              = "ingress"
  from_port         = <%= PORT %>
  to_port           = <%= PORT %>
  description       = "Access to the <%= NAME %>"
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.<%= NAME %>-sg.id}"
}

#-------------------
# Outputs
#-------------------

output "<%= NAME %>_alb_sg_id" {
  value = "${aws_security_group.<%= NAME %>-alb-sg.id}"
}

#-------------------#