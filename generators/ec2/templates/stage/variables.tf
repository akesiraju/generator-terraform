#--------------------------------------------------------------
# <%= NAME %> ec2 instance 
#--------------------------------------------------------------

variable "<%= NAME %>_ec2_name"                           {default = "<%= NAME %>"}
variable "<%= NAME %>_ec2_ami"                            {default = "ami-f102ad8c"}
variable "<%= NAME %>_ec2_count"                          {default = "<%= COUNT %>"}
variable "<%= NAME %>_ec2_instance_type"                  {default = "t2.medium"}
variable "<%= NAME %>_ec2_key_name"                       {default = "se_tools_key-poc"}