#--------------------------------------------------------------
# <%= NAME %> RDS DB instance
#--------------------------------------------------------------

# Create Subnet Group for DB instance

resource "aws_db_subnet_group" "<%= NAME %>-rds-subnet-group" {
  #name of the resource group, it is optional, but must be unique
  name       = "${var.environment}.${var.<%= NAME %>_rds_name}-rds-db-subnet-group"
  subnet_ids = ["${var.subnet_ids}"]
  description = "${var.environment}.${var.<%= NAME %>_rds_name}-subnet-group for <%= NAME%> RDS DB"

  tags {
    Name = "${var.environment}.${var.<%= NAME %>_rds_name}-rds-db-subnet-group"
    Terraform = "true"
    Environment = "${var.environment}"
  }
}

# Create DB instance
resource "aws_db_instance" "<%= NAME %>-rds"  {
    identifier                = "${var.environment}-${var.<%= NAME %>_rds_name}-rds-db"
    allocated_storage         = 100
    storage_type              = "gp2"
    engine                    = "<%= ENGINE %>"
    engine_version            = "5.6.37"
    instance_class            = "${var.<%= NAME %>_rds_instance_class}"
    name                      = "${var.<%= NAME %>_rds_name}${var.environment}"        # Name of DB created on launch
    username                  = "${var.<%= NAME %>_rds_username}"
    password                  = "${var.<%= NAME %>_rds_password}"      # Configured in terraform.tfvars
    port                      = <%= PORT %>
    publicly_accessible       = false
    availability_zone         = "${element(var.availability_zones,count.index)}"
#    security_group_names      = []   #Deprecated in Terraform 0.9.11
    vpc_security_group_ids    = ["${aws_security_group.<%= NAME %>-rds-sg.id}"]
    db_subnet_group_name      = "${aws_db_subnet_group.<%= NAME %>-rds-subnet-group.name}"
    parameter_group_name      = "default.<%= ENGINE %>"
    multi_az                  = false
    backup_retention_period   = 7    
    final_snapshot_identifier = "${var.environment}-${var.<%= NAME %>_rds_name}-rds-db-final"

    tags {
      Name = "${var.environment}-${var.<%= NAME %>_rds_name}-rds-db"
      Terraform = "true"
      Environment = "${var.environment}"
    }

  lifecycle {
    ignore_changes = "password,parameter_group_name"
   }  
}

#-------------------
# Outputs
#-------------------


output "<%= NAME %>-rds-subnet-group_id"     { value = "${aws_db_subnet_group.<%= NAME %>-rds-subnet-group.id}" }
output "<%= NAME %>-rds-subnet-group_arn"    { value = "${aws_db_subnet_group.<%= NAME %>-rds-subnet-group.arn}" }
output "<%= NAME %>_rds_id"                  { value = "${aws_db_instance.<%= NAME %>-rds.id}" }
output "<%= NAME %>_rds_arn"                 { value = "${aws_db_instance.<%= NAME %>-rds.arn}" }
output "<%= NAME %>_rds_endpoint"            { value = "${aws_db_instance.<%= NAME %>-rds.endpoint}" }

#-------------------#