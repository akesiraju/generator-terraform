#<%= NAME %> Variables

#common
variable "environment"                                              {}

variable "availability_zones"                                       {  type = "list"}

variable "vpc_id"                                                   { }

#ec2
variable "<%= NAME %>_ec2_name"                                    {}

variable "<%= NAME %>_ec2_ami"                                     {}
variable "<%= NAME %>_ec2_count"                                   {}
variable "<%= NAME %>_ec2_instance_type"                           {}
variable "<%= NAME %>_ec2_key_name"                                {}

variable "subnet_ids"                                               {  type = "list"}