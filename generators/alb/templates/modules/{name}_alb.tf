# Create application load balancer (alb) - internal

# sg(s) created in a separate .tf file

#alb: load balancer
resource "aws_alb" "<%= NAME %>_alb" {
  name            = "${var.environment}-${var.<%= NAME %>_ec2_name}-alb"
  internal        = true
  security_groups = ["${aws_security_group.<%= NAME %>-sg.id}"]
  subnets         = ["${var.subnet_ids}"]

  enable_deletion_protection = true
  idle_timeout = 180

  tags {
    Name = "${var.environment}-${var.<%= NAME %>_ec2_name}-alb"
    Terraform = "true"
    Environment = "${var.environment}"
  }
}

#alb: target group
resource "aws_alb_target_group" "<%= NAME %>_alb_tg" {
  name     = "${var.environment}-${var.<%= NAME %>_ec2_name}-alb-tg"
  port     = "<%= PORT %>"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  
  health_check {
    path = "/status"
    port     = "traffic-port"
    protocol = "HTTP"
    interval = "120"
    timeout = "10"
    healthy_threshold = "5"
    matcher = "200"
    unhealthy_threshold = "2"    
  }

  deregistration_delay = "30"
}

#alb: listener
resource "aws_alb_listener" "<%= NAME %>_alb_listener" {
  load_balancer_arn = "${aws_alb.<%= NAME %>_alb.arn}"
  port              = "<%= PORT %>"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.<%= NAME %>_alb_tg.arn}"
    type             = "forward"
  }
}

#alb: listener-rule
resource "aws_lb_listener_rule" "<%= NAME %>_alb_rule" {
  listener_arn = "${aws_alb_listener.<%= NAME %>_alb_listener.arn}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.<%= NAME %>_alb_tg.arn}"
  }

  condition {
    field  = "host-header"
    values = ["*.*"]
  }
}

#alb: target group attachment
resource "aws_alb_target_group_attachment" "<%= NAME %>_alb_tg_attachment" {
  target_group_arn = "${aws_alb_target_group.<%= NAME %>_alb_tg.arn}"
#  count            = "${var.<%= NAME %>_ec2_count}"
#  target_id        = "${element(aws_instance.<%= NAME %>.id,count.index)}"
# Multiple target IDs not supported in the current version of Terraform
# 0.9.4: https://github.com/hashicorp/terraform/pull/9986
  target_id        = "${aws_instance.<%= NAME %>.0.id}"
  port             = "<%= PORT %>"

  depends_on      = ["aws_instance.<%= NAME %>"]
}