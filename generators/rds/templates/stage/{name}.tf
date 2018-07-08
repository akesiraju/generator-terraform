module "<%= NAME %>" {
    source  = "../modules/<%= NAME %>"

    environment = "${var.environment}"
    
    availability_zones = "${data.terraform_remote_state.aws_infra.services_vpc-azs}"
    vpc_id = "${data.terraform_remote_state.aws_infra.services_vpc-vpc_id}"
    subnet_ids  = "${data.terraform_remote_state.aws_infra.services_se_private_sub-subnet_ids}"

    <%= NAME %>_rds_name                         =  "${var.<%= NAME %>_rds_name}"
    <%= NAME %>_rds_username                     =  "${var.<%= NAME %>_rds_username}"
    <%= NAME %>_rds_password                     =  "${var.<%= NAME %>_rds_password}"
    <%= NAME %>_rds_instance_class               =  "${var.<%= NAME %>_rds_instance_class}"
}