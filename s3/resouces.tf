resource "aws_s3_bucket" "b" {
  bucket = "my-tff2-bucket"
  acl    = "public-read"

  tags = {
    Name        = "testingtesting"
    Environment = "Dev"
  }
}
