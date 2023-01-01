terraform {
  backend "s3" {
    bucket = "s3-ca"
    key    = "path/to/my/key"
    region = "us-east-1"
  }
}
