#--------------------------------------------------------------
# <%=NAME %>_rds RDS instance and DB
#--------------------------------------------------------------

variable "<%=NAME %>_rds_name"                                  {default = "<%=NAME %>"}
variable "<%=NAME %>_rds_username"                              {default = "<%=NAME %>_sa"}
variable "<%=NAME %>_rds_password"                              {default = "change-me"}
variable "<%=NAME %>_rds_instance_class"                        {default = "db.t2.small"}