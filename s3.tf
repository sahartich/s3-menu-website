resource "aws_s3_bucket" "main" {
  bucket = "menu.tichover.tech"
  tags = {
    Name        = "static website"
    Environment = "Web-${terraform.workspace}" # just for funsies
  }
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.restrict-ip.json
  lifecycle {
    ignore_changes = [policy]
  }
}

resource "aws_s3_object" "index" {
  key          = "index.html"
  bucket       = aws_s3_bucket.main.id
  source       = "Website/index.html"
  content_type = "text/html"

  tags = {
    Env = "Web-${terraform.workspace}"
  }
}

resource "aws_s3_object" "css" {
  key          = "styles.css"
  bucket       = aws_s3_bucket.main.id
  source       = "Website/styles.css"
  content_type = "text/css"

  tags = {
    Env = "Web-${terraform.workspace}"
  }
}

resource "aws_s3_bucket_website_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  index_document {
    suffix = aws_s3_object.index.key
  }
}

resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "main" { # not specifying anything will allow public access by default
  bucket = aws_s3_bucket.main.id
}