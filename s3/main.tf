resource "aws_s3_bucket" "bucket"{
  bucket = "rental-service-api-v1"
  acl    = "private"

  tags {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
