#--------------------------------------------------------------
# API - <%= NAME %> - EC2 instance(s)
#--------------------------------------------------------------

# sg(s) created in a separate .tf file

#Create instance
resource "aws_instance" "<%= NAME %>" {
  ami                    = "${var.<%= NAME %>_ec2_ami}"
  availability_zone      = "${element(var.availability_zones,count.index)}"
  ebs_optimized          = false
  instance_type          = "${var.<%= NAME %>_ec2_instance_type}"
  monitoring             = false
  key_name               = "${var.<%= NAME %>_ec2_key_name}"
  count                  = "${var.<%= NAME %>_ec2_count}"
  subnet_id              = "${element(var.subnet_ids,count.index)}"
  vpc_security_group_ids = ["${aws_security_group.<%= NAME %>-sg.id}"]

  associate_public_ip_address = false

  #    private_ip                  = "A.B.C.D"
  source_dest_check = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = <%= SIZE %>
    delete_on_termination = true
  }

  tags {
    Name        = "${var.environment}.${element(var.availability_zones, count.index)}.${var.<%= NAME %>_ec2_name}-i"
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}

#-------------------
# Outputs
#-------------------

output "<%= NAME %>_id" {
  value = ["${aws_instance.<%= NAME %>.*.id}"]
}

output "<%= NAME %>_private_ip" {
  value = ["${aws_instance.<%= NAME %>.*.private_ip}"]
}

#-------------------#