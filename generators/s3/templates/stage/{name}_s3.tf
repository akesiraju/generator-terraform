#--------------------------------------------------------------
# <%= NAME %> - S3 buckets
#--------------------------------------------------------------

# For permissions (acl) see canned ACL
# https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl

#Create S3 bucket
resource "aws_s3_bucket" "<%= NAME %>_s3" {
  bucket = "${var.environment}.<%= NAME %>-s3"
  acl    = "private"   #Owner gets full control

  versioning {
  enabled = true
  }

  tags {
    Name        = "${var.environment}.<%= NAME %>-s3"
    Terraform = "true"
    Environment = "${var.environment}"
  }
}

#-------------------
# Outputs
#-------------------

output "<%= NAME %>_s3_id"                      { value = "${aws_s3_bucket.<%= NAME %>_s3.id}" }
output "<%= NAME %>_s3_bucket_domain_name"      { value = "${aws_s3_bucket.<%= NAME %>_s3.bucket_domain_name }" }

#---------------------#