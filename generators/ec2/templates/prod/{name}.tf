module "<%= NAME %>" {
  source = "../modules/<%= NAME %>"

  environment                       = "${var.environment}"

  availability_zones                = "${data.terraform_remote_state.aws_infra.services_vpc-azs}"
  vpc_id                            = "${data.terraform_remote_state.aws_infra.services_vpc-vpc_id}"
  subnet_ids                        = "${data.terraform_remote_state.aws_infra.services_se_private_sub-subnet_ids}"

  <%= NAME %>_ec2_name             = "${var.<%= NAME %>_ec2_name}"
  <%= NAME %>_ec2_ami              = "${var.<%= NAME %>_ec2_ami}"
  <%= NAME %>_ec2_count            = "${var.<%= NAME %>_ec2_count}"
  <%= NAME %>_ec2_instance_type    = "${var.<%= NAME %>_ec2_instance_type}"
  <%= NAME %>_ec2_key_name         = "${var.<%= NAME %>_ec2_key_name}"
}